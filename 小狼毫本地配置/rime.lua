require("mydate")
require("unicode")
require("number")
require("emoji")
require("basefunctions")

-- global lua help tips
function Lua_Tips(input,seg, env)
	if input:match("^/$") then 
		local segment = env.engine.context.composition:back()
		segment.prompt = "~? [获得输入帮助]"
		return
	end
	if input:match("^/%?$") then
		local segment = env.engine.context.composition:back()
		segment.prompt = "Lua快捷输入帮助"
		local emoji_tips = Emoji_Tips()
		local daxie_tips = Daxie_Tips()
		local unicode_tips = Unicode_Tips()
		local date_tips = Date_Tips()
		yield(Candidate("tips", seg._start, seg._end, emoji_tips, ""))
		yield(Candidate("tips", seg._start, seg._end, date_tips, ""))
		yield(Candidate("tips", seg._start, seg._end, unicode_tips, ""))
		yield(Candidate("tips", seg._start, seg._end, daxie_tips, ""))
	end
end


--must after function definitions
local english = require("english")()
english_processor = english.processor
english_segmentor = english.segmentor
english_translator = english.translator
english_filter = english.filter
english_filter0 = english.filter0

function date_translator(input, seg)
    if (input == "date") then
        --- Candidate(type, start, end, text, comment)
        yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("%m-%d"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d"), ""))
    end
    if (input == "time") then
        --- Candidate(type, start, end, text, comment)
        yield(Candidate("time", seg.start, seg._end, os.date("%H:%M"), ""))
        yield(Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), ""))
    end
    if (input == "shijian") then
        --- Candidate(type, start, end, text, comment)
        yield(Candidate("shijian", seg.start, seg._end, os.date("%Y-%m-%d %H:%M:%S"), ""))
        yield(Candidate("shijian", seg.start, seg._end, os.date("%Y年%m月%d日 %H:%M:%S"), ""))
    end
    if (input == "sj") then
        --- Candidate(type, start, end, text, comment)
        yield(Candidate("sj", seg.start, seg._end, os.date("%Y-%m-%d %H:%M:%S"), ""))
        yield(Candidate("sj", seg.start, seg._end, os.date("%Y年%m月%d日 %H:%M:%S"), ""))
    end

    -- @JiandanDream
    -- https://github.com/KyleBing/rime-wubi86-jidian/issues/54

    if (input == "week") then
        local weakTab = {'日', '一', '二', '三', '四', '五', '六'}
        yield(Candidate("week", seg.start, seg._end, "周"..weakTab[tonumber(os.date("%w")+1)], ""))
        yield(Candidate("week", seg.start, seg._end, "星期"..weakTab[tonumber(os.date("%w")+1)], ""))
        yield(Candidate("week", seg.start, seg._end, "礼拜"..weakTab[tonumber(os.date("%w")+1)], ""))
    end
end

--- 过滤器：单字在先
function single_char_first_filter(input)
    local l = {}
    for cand in input:iter() do
        if (utf8.len(cand.text) == 1) then
            yield(cand)
        else
            table.insert(l, cand)
        end
    end
    for cand in ipairs(l) do
        yield(cand)
    end
end


