textinput = nil

function descriptor()
	return {
		title = "Jump subtitle",
		version = "1.0",
		author = "fireinureeyes",
		url = "",
		description = [[Jump to the next or previous subtitle location in the video.]],
		capabilities = {}
	}
end
function activate()
	create_dialog()
end
function deactivate()
end
function close()
		vlc.deactivate()
end
function meta_changed()
	return false
end

function create_dialog()
	dlg = vlc.dialog("Jump subtitle")
	if vlc.input.item() and Load_subtitles() then
		-- column, row, col_span, row_span
		dlg:add_label("Jump to the previous or next subtitle location:",1, 1, 8, 1)
		dlg:add_button("Previous",previous, 1, 2, 4, 1)
		dlg:add_button("Next",next, 5, 2, 4, 1)
		dlg:add_label("Jump max by (0 = unlimited) seconds:",1, 3, 8, 1)
		textinput = dlg:add_text_input("10", 1, 4, 8, 1)
	end
end

function dialogbox_label(label_text)
	if w1 then dlg:del_widget(w1) end
	w1 = dlg:add_label(label_text)
	dlg:update()
end

function Load_subtitles()
	subtitles_uri = nil -- "file:///D:/films/subtitles.srt"
	filename_extension = "srt"
	charset = "Windows-1250" -- nil or "UTF-8", "ISO-8859-2", ...
	if subtitles_uri==nil then subtitles_uri=media_path(filename_extension) end
-- read file
	local s = vlc.stream(subtitles_uri)
	if s==nil then return false end
	data = s:read(500000)
	data = string.gsub( data, "\r", "")
	-- UTF-8 BOM detection
	if string.char(0xEF,0xBB,0xBF)==string.sub(data,1,3) then charset=nil end
-- parse data
	subtitles={}
	srt_pattern = "(%d%d):(%d%d):(%d%d),(%d%d%d) %-%-> (%d%d):(%d%d):(%d%d),(%d%d%d).-\n(.-)\n\n"
	for h1, m1, s1, ms1, h2, m2, s2, ms2, text in string.gmatch(data, srt_pattern) do
		if text=="" then text=" " end
		if charset~=nil then text=vlc.strings.from_charset(charset, text) end
		table.insert(subtitles,{format_time(h1, m1, s1, ms1), format_time(h2, m2, s2, ms2), text})
	end
	if #subtitles~=0 then return true else return false end
end
function format_time(h,m,s,ms) -- time to seconds
	return (tonumber(h)*3600+tonumber(m)*60+tonumber(s)+tonumber("."..ms))*1000000 -- VLC 3 microseconds fix
end
function media_path(extension)
	local media_uri = vlc.input.item():uri()
	media_uri = string.gsub(media_uri, "^(.*)%..-$","%1") .. "." .. extension
	return media_uri
end

function previous()
	subtitle=nil
	local input = vlc.object.input()
	local actual_time = vlc.var.get(input, "time")
	local max_jump = tonumber(textinput:get_text()) * 1000000 -- convert to microseconds
	local previous_subtitle = nil
	for i, v in pairs(subtitles) do
		if actual_time > v[1] then
			previous_subtitle = v
		else
			break
		end
	end
	if previous_subtitle then
		if max_jump == 0 or (actual_time - previous_subtitle[1]) <= max_jump then
			subtitle = previous_subtitle
			vlc.var.set(input, "time", subtitle[1])
		else
			vlc.var.set(input, "time", actual_time - max_jump)
			vlc.msg.info("Previous subtitle is more than " .. max_jump / 1000000 .. " seconds away. Jumping by max jump time.")
		end
	end
end

function next()
	subtitle=nil
	local input = vlc.object.input()
	local actual_time = vlc.var.get(input, "time")
	local max_jump = tonumber(textinput:get_text()) * 1000000 -- convert to microseconds
	for i, v in pairs(subtitles) do
		if actual_time < v[1] then
			if max_jump == 0 or (v[1] - actual_time) <= max_jump then
				subtitle = v
				vlc.var.set(input, "time", subtitle[1])
			else
				vlc.var.set(input, "time", actual_time + max_jump)
				vlc.msg.info("Next subtitle is more than " .. max_jump / 1000000 .. " seconds away. Jumping by max jump time.")
			end
			break
		end
	end
end
