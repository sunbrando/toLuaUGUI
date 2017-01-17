--------------------------------------------------------------------------------------------
-- @description 该文件存放一些全局的公共函数
-- @author zhongliang
-- @coryright 蜂鸟工作室
-- @release 2016-02-03
--------------------------------------------------------------------------------------------

-- 获取调用函数的文件名、函数名 --
function getTraceCaller(traceLineNum)
    local trace = debug.traceback()
    trace = string.gsub(trace, "\\", "/")

    traceLineNum = traceLineNum or 4
    local lastPos = 1
    local pos = 1
    for i = 1, traceLineNum do
        lastPos = pos + 1
        pos = string.find(trace, "\n", lastPos)
        if pos == nil then
            break
        end
    end

    local line = nil
    if pos == nil then
        line = string.sub(trace, lastPos)
    else
        line = string.sub(trace, lastPos, pos)
    end

    local fileName, lineNum, funcName = nil, nil, nil
    fileName, lineNum = string.match(line, '%<%[string %"[%w_%/]+%/([%w_]+%.lua)%"%]:(%d+)')
    if fileName == nil or lineNum == nil then
        fileName, lineNum, funcName = string.match(line, '<[%w_%/:]+%/([%w_]+%.lua):(%d+)>')
    end
    if fileName == nil or lineNum == nil then
        fileName, lineNum, funcName = string.match(line, "([%w_]+%.lua):(%d+): in function '([%w_]+)'")
    end
    if fileName == nil or lineNum == nil then
        fileName, lineNum = string.match(line, "([%w_]+%.lua):(%d+): in function")
    end

    return string.format(" @ [%s:%s] %s", tostring(fileName), tostring(lineNum), tostring(funcName))
end

-- 输出日志--
function log(str, ...)
    print(str, ...)
end

-- 输出错误日志--
function logError(str, ...)
    --str = str .. getTraceCaller()
    --Util.LogError(string.format(tostring(str), ...))
    print(string.format('<color=red><Error>: %s</color>', str), ...)
end

-- 输出警告日志--
function logWarn(str, ...)
--        str = str .. getTraceCaller()
--        Util.LogWarning(string.format(tostring(str), ...))
    print(string.format('<color=yellow><Warning>: %s</color>', str), ...)
end

-- 输出值的内容--
-- @param mixed value 要输出的值
-- @param [string desciption] 输出内容前的文字描述
-- @parma [integer nesting] 输出时的嵌套层级，默认为 3
function dump(value, desciption, nesting)
    if type(nesting) ~= "number" then nesting = 3 end

    local lookupTable = { }
    local result = { }

    local function _v(v)
        if type(v) == "string" then
            v = "\"" .. v .. "\""
        end
        return tostring(v)
    end

    local traceback = string.split(debug.traceback("", 2), "\n")
    print("dump from: " .. string.trim(traceback[3]))
    local spc
    local function _dump(value, desciption, indent, nest, keylen)
        desciption = desciption or "<var>"
        spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(_v(desciption)))
        end
        if type(value) ~= "table" then
            result[#result + 1] = string.format("%s%s%s = %s", indent, _v(desciption), spc, _v(value))
        elseif lookupTable[value] then
            result[#result + 1] = string.format("%s%s%s = *REF*", indent, desciption, spc)
        else
            lookupTable[value] = true
            if nest > nesting then
                result[#result + 1] = string.format("%s%s = *MAX NESTING*", indent, desciption)
            else
                result[#result + 1] = string.format("%s%s = {", indent, _v(desciption))
                local indent2 = indent .. "    "
                local keys = { }
                local keylen = 0
                local values = { }
                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = _v(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then keylen = vkl end
                    values[k] = v
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end )
                for i, k in ipairs(keys) do
                    _dump(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result + 1] = string.format("%s}", indent)
            end
        end
    end
    _dump(value, desciption, "- ", 1)

    local desc = ""
    for i, line in ipairs(result) do
        desc = desc .. line .. "\n"
    end
    print("---------------------dump-------------------\n" .. desc)
end

-- 类内部回调函数封装--
function handler(obj, method)
    return function(...)
        return method(obj, ...)
    end
end

-- 判断是否为函数--
function isFunction(f)
    return type(f) == 'function'
end

-- 判断是否为一个表格--
function isTable(value)
    return type(value) == 'table'
end

-- 检查并尝试转换为数值，如果无法转换则返回0--
function checknumber(value)
    return tonumber(value) or 0
end

-- 检查并尝试转换为整数，如果无法转换则返回0--
function checkint(value)
    return math.round(checknumber(value))
end

-- 检查并尝试转换为布尔值，除了 nil 和 false，其他任何值都会返回 true--
function checkbool(value)
    return(value ~= nil and value ~= false)
end

-- 检查值是否是一个表格，如果不是则返回一个空表格--
function checktable(value)
    if type(value) ~= "table" then value = { } end
    return value
end

--获取随机数（整型）--
function randomInt(minValue, maxValue)
    return checkint(Util.Random(minValue, maxValue))
end

--获取随机数（浮点型）--
function randomFloat(minValue, maxValue)
    return Util.Random(minValue, maxValue)
end

-- 计算表格包含的字段数量--
function table.count(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

-- 返回指定表格中的所有键--
function table.keys(hashtable)
    local keys = { }
    for k, v in pairs(hashtable) do
        keys[#keys + 1] = k
    end
    return keys
end

-- 返回指定表格中的所有值--
function table.values(hashtable)
    local values = { }
    for k, v in pairs(hashtable) do
        values[#values + 1] = v
    end
    return values
end

-- 将来源表格中所有键及其值复制到目标表格对象中，如果存在同名键，则覆盖其值--
function table.merge(dest, src)
    for k, v in pairs(src) do
        dest[k] = v
    end
end

-- 在目标表格的指定位置插入来源表格，如果没有指定位置则连接两个表格--
function table.insertto(dest, src, begin)
    begin = begin or 0
    if begin <= 0 then
        begin = #dest + 1
    end

    local len = #src
    for i = 0, len - 1 do
        dest[i + begin] = src[i + 1]
    end
end

-- 从表格中查找指定值，返回其索引，如果没找到返回 false--
function table.indexof(array, value, begin)
    for i = begin or 1, #array do
        if array[i] == value then return i end
    end
    return false
end

-- 从表格中查找指定值，返回其 key，如果没找到返回 nil--
function table.keyof(hashtable, value)
    for k, v in pairs(hashtable) do
        if v == value then return k end
    end
    return nil
end

-- 从表格中删除指定值，返回删除的值的个数--
function table.removebyvalue(array, value, removeall)
    local c, i, max = 0, 1, #array
    while i <= max do
        if array[i] == value then
            table.remove(array, i)
            c = c + 1
            i = i - 1
            max = max - 1
            if not removeall then break end
        end
        i = i + 1
    end
    return c
end

-- 对表格中每一个值执行一次指定的函数，并用函数返回值更新表格内容--
function table.map(t, fn)
    t = checktable(t)
    for k, v in pairs(t) do
        t[k] = fn(v, k)
    end
end

-- 对表格中每一个值执行一次指定的函数，但不改变表格内容--
function table.walk(t, fn)
    t = checktable(t)
    for k, v in pairs(t) do
        fn(v, k)
    end
end

-- 对表格中每一个值执行一次指定的函数，如果该函数返回false，则对应的值会从表格中删除--
function table.filter(t, fn)
    for k, v in pairs(t) do
        if not fn(v, k) then t[k] = nil end
    end
end

-- 遍历表格，确保其中的值唯一--
function table.unique(t)
    local check = { }
    local n = { }
    for k, v in pairs(t) do
        if not check[v] then
            n[k] = v
            check[v] = true
        end
    end
    return n
end

-- 判断表格中是否包含指定的key--
function table.containKey(t, key)
    for k, v in pairs(t) do
        if key == k then
            return true;
        end
    end
    return false;
end

-- 判断表格中是否包含指定的value--
function table.containValue(t, value)
    for k, v in pairs(t) do
        if v == value then
            return true;
        end
    end
    return false;
end

-- 清空一个表格--
function table.clear(t)
    if type(t) == 'table' then
        table.map(t, function()
            return nil
        end)
    end
end

--对数值进行四舍五入，如果不是数值则返回 0--
function math.round(value)
    return math.floor(value + 0.5)
end

-- 用指定字符或字符串分割输入字符串，返回包含分割结果的数组--
function string.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter == '') then return false end
    local pos, arr = 0, { }
    for st, sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

-- 去除输入字符串头部的空白字符，返回结果--
function string.ltrim(input)
    return string.gsub(input, "^[ \t\n\r]+", "")
end

-- 去除输入字符串尾部的空白字符，返回结果--
function string.rtrim(input)
    return string.gsub(input, "[ \t\n\r]+$", "")
end

-- 去掉字符串首尾的空白字符，返回结果--
function string.trim(input)
    input = string.gsub(input, "^[ \t\n\r]+", "")
    return string.gsub(input, "[ \t\n\r]+$", "")
end

-- 将字符串的第一个字符转为大写，返回结果--
function string.ucfirst(input)
    return string.upper(string.sub(input, 1, 1)) .. string.sub(input, 2)
end

local function urlencodechar(char)
    return "%" .. string.format("%02X", string.byte(char))
end

-- 将字符串转换为符合 URL 传递要求的格式，并返回转换结果--
function string.urlencode(input)
    input = string.gsub(tostring(input), "\n", "\r\n")
    input = string.gsub(input, "([^%w%.%- ])", urlencodechar)
    return string.gsub(input, " ", "+")
end

-- 将 URL 中的特殊字符还原，并返回结果--
function string.urldecode(input)
    input = string.gsub(input, "+", " ")
    input = string.gsub(input, "%%(%x%x)", function(h) return string.char(checknumber(h, 16)) end)
    input = string.gsub(input, "\r\n", "\n")
    return input
end

-- 计算 UTF8 字符串的长度，每一个中文算一个字符--
function string.utf8len(input)
    local len = string.len(input)
    local left = len
    local cnt = 0
    local arr = { 0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc }
    while left ~= 0 do
        local tmp = string.byte(input, - left)
        local i = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
    end
    return cnt
end

-- 将数值格式化为包含千分位分隔符的字符串--
function string.formatnumberthousands(num)
    local formatted = tostring(checknumber(num))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

-- 格式化数字成K,M,G标识字符串--
-- 标准化后如果数字不超过10，则显示小数点后2位
-- 标准化后如果数字不超过100，则显示小数点后1位
-- 标准化后如果超过100则不显示小数位 
function formatNumber(num)
    num = checknumber(num)
    if num < 1000 then
        return tostring(num)
    elseif num < 1000000000000 then
        local baseNum = 1000
        local unit = 'K'
        if num >= 1000000 and num < 1000000000 then
            baseNum = 1000000
            unit = 'M'
        elseif num >= 1000000000 then
            baseNum = 1000000000
            unit = 'G'
        end
        num = num / baseNum
        if num < 10 then
            return string.format("%.2f", num) .. unit
        elseif num < 100 then
            return string.format("%.1f", num) .. unit
        else
            return string.format("%d", num) .. unit
        end
    end
    return tostring(num)
end

-- 格式化时间成h，m，s标识字符串--
function formatTime(num)
    num = checknumber(num)
    num = math.ceil(num)
    if num < 3600 then
        local minute = math.floor(num / 60)
        local second = num - minute * 60
        return string.format('%dm%ds', minute, second)
    elseif num < 86400 then
        local hour = math.modf(num / 3600)
        local minute = math.modf((num % 3600) / 60)
        return string.format('%dh%dm', hour, minute)
    else
        local day = math.modf(num / 86400)
        local hour = math.modf((num % 86400) / 3600)
        return string.format('%dd%dh', day, hour)
    end
end

-- 返回天、时、分、秒 --
function getformatTime(num)
    num = checknumber(num)
    num = math.ceil(num)
    local day, hour, minute, second = 0, 0, 0, 0
    if num >= 86400 then
        day = math.floor(num / 86400)
        hour = math.floor((num - day*86400) / 3600)
        minute = math.floor((num - day*86400 - hour*3600) / 60)
    elseif num >= 3600 then
        hour = math.floor(num / 3600)
        minute = math.floor((num - hour * 3600) / 60)
        second = num - hour * 3600 - minute * 60
    elseif num < 3600 and num >= 60 then
        minute = math.floor(num / 60)
        second = num - minute * 60
    elseif num < 60 then
        second = num
    end

    return day, hour, minute, second
end

--延时执行指定的函数--
function exeFuncWithDelayTime(func, duration, count)
    if duration == nil then 
        func()
    else
        count = count or 1
        Timer.New(function(num)
            func(num)
        end, tonumber(duration), tonumber(count)):Start()
    end
end

-- 给文字加颜色
function addColor(text, colorNum)
    return string.format("<color=#%s>%s</color>", colorNum, tostring(text))
end

-- 去除文字颜色
function removeColor(text)
    text = string.gsub(tostring(text), '<color=#%w+>', '')
    text = string.gsub(text, '</color>', '')
    return text
end

-- 打印函数执行时间--
function logTimeWithFunction(func)
    local startTime = os.clock()
    if isFunction(func) then func() end
    log('执行耗时: ' .. tostring(os.clock() - startTime))
end

-- 获取文件名，包含扩展名
function getFileName(fileName)
    local sfn_flag = string.find(fileName, "\\")
    local sdest_filename
    if sfn_flag then
        sdest_filename = string.match(fileName, ".+\\([^\\]*%.%w+)$")
    end
    sfn_flag = string.find(fileName, "/")
    if sfn_flag then
        sdest_filename = string.match(fileName, ".+/([^/]*%.%w+)$")
    end
    return sdest_filename
end

-- 获取扩展名
function getFileExtension(fileName)
    return fileName:match(".+%.(%w+)$")
end

-- 获取文件名，不包含扩展名
function getFileNameWithoutExtension(fileName)
    return stripFileExtension(getFileName(fileName))
end

-- 文件名去除扩展名  
function stripFileExtension(fileName)
    local idx = fileName:match(".+()%.%w+$")
    if (idx) then
        return fileName:sub(1, idx - 1)
    else
        return fileName
    end
end 

-- 获取全路径  
function getFileFullPath(sFileFullName)
    local fileNameWithoutExt = getFileNameWithoutExtension(sFileFullName)
    return string.sub(stripFileExtension(sFileFullName), 1, - string.len(fileNameWithoutExt) -2)
    -- 还有一个/
end

-- 创建聊天表情的文件路径 --
function createChatFacePath(filename)
    return "UI/Chat/" .. filename
end

-- 创建用户头像的文件路径 --
function createUserAvatorPath(name, gender)
-- 头像id全部使用1-12的数字
    if name == 1 or name == 'default' then
        --  默认头像 男1 女4
        if gender ~= Constant.gender.male then
            name = 4
        else
            name = 1
        end
    end

    return string.format('UI/Item/head_%02d.png', name)
end

-- 根据配置表中的奖励结构，获得奖励数据列表，此数据结构根服务器返回的奖励结构一致，
-- 可以直接带入PropGrid中得出格子界面
-- 奖励字符串结构必须按 item:item_06601=3000,item_06602=1500,item_06603=200，此结构，返回{type=xxx, id=xxx, num=xxx}的结构的列表
-- 配置的类型必须跟Constant.eRewardType中的值一致
function getRewardFormatTableList(sRewardStr)
    -- 奖励的类型和id，与奖励结构的对应表，用于相同类型和相同id的数据叠加，防止重复；如：item:item_06601=3000;item:item_06601=2000
    local tlRewardData = { }
    local tlRewardSplitType = string.split(sRewardStr, ';')
    -- 以奖励种类来分割出来
    for i = 1, #tlRewardSplitType do
        local tmTypeWithReward = string.split(tlRewardSplitType[i], ':')
        if #tmTypeWithReward ~= 2 then break end
        -- 获得类型
        local sRewardType = tmTypeWithReward[1]
        local tlAllRewardWithType = string.split(tmTypeWithReward[2], ',')
        -- 获得当前种类的全部奖励数据
        for j = 1, #tlAllRewardWithType do
            -- 一个一个的放入列表中
            local tmRewardIdWithNum = string.split(tlAllRewardWithType[j], '=')
            if #tmRewardIdWithNum ~= 2 then break end
            local tmKey = string.format('%s:%s', sRewardType, tmRewardIdWithNum[1])
            -- 为了保证顺序，所以用遍历检查的方法
            local bIsContain = false
            for k = 1, #tlRewardData do
                if string.format('%s:%s', tlRewardData[k].type, tlRewardData[k].id) == tmKey then
                    tlRewardData[k].num = tlRewardData[k].num + checknumber(tmRewardIdWithNum[2])
                    bIsContain = true
                    break
                end
            end
            if not bIsContain then
                tlRewardData[#tlRewardData + 1] = { type = sRewardType, id = tmRewardIdWithNum[1], num = checknumber(tmRewardIdWithNum[2]) }
            end
        end
    end
    return tlRewardData
end

--字符转变，用于图片字使用--
--比如123 需要转成 abc 才能使用
function charChange(text, num)
    local tlChat = {}
    local length = string.len(text)
    while length > 0 do
        table.insert(tlChat, string.char(string.byte(string.sub(text, 1, 1)) + num))
        text = string.sub(text, 2)
        length = string.len(text)
    end
    return table.concat(tlChat)
end

--判断点在矩形内--
function pointInRect(rect, p)
    return p.x >= rect.position.x and
           p.x <= rect.position.x + rect.size.x and
           p.y >= rect.position.y and
           p.y <= rect.position.y + rect.size.y
end

--判断2D线段p1-p2 与 p3-p4是否相交，相交时返回交点--
--http://www.wyrmtale.com/blog/2013/115/2d-line-intersection-in-c
--http://www.stefanbader.ch/faster-line-segment-intersection-for-unity3dc/
function lineSegmentIntersection(p1, p2, p3, p4)
    local a = p2 - p1
    local b = p3 - p4
    local c = p1 - p3

    local alphaNumerator = b.y * c.x - b.x * c.y;
    local alphaDenominator = a.y * b.x - a.x * b.y;
    local betaNumerator = a.x * c.y - a.y * c.x;
    local betaDenominator = alphaDenominator;

    local c1 = a.y * p1.x - a.x * p1.y;
    local c2 = b.x * p3.y - b.y * p3.x;

    local doIntersect = true;

    if alphaDenominator == 0 or betaDenominator == 0 then
        doIntersect = false;
    else
        if alphaDenominator > 0 then
            if alphaNumerator < 0 or alphaNumerator > alphaDenominator then
                doIntersect = false
            end
        elseif alphaNumerator > 0 or alphaNumerator < alphaDenominator then
            doIntersect = false;
        end

        if doIntersect and betaDenominator > 0 then
            if betaNumerator < 0 or betaNumerator > betaDenominator then
                doIntersect = false;
            end
        elseif betaNumerator > 0 or betaNumerator < betaDenominator then
            doIntersect = false;
        end
    end

    if doIntersect then
        local delta = a.y * b.x - b.y * a.x;
        return true, Vector2.New((b.x * c1 + a.x * c2) / delta, (a.y * c2 + b.y * c1) / delta)
    end

    return false
end
