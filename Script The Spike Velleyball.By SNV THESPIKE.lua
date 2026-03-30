    gg.alert("❌ មិនមានតម្លៃត្រូវគ្នា")
local datetime = os.date("%Y-%m-%d %H:%M:%S")
local v = gg.getTargetInfo().versionName

local title = "Script THE Spike Volleyball\n📌 Version: " .. v ..
              "\n📅 ថ្ងៃ ខែ ឆ្នាំ ម៉ោងប្រើប្រាស់៖ " .. datetime ..
              "\nScript The Spike GG by សុខ អែណាវ🇰🇭🇰🇭"
gg.setRanges(gg.REGION_C_ALLOC)
gg.clearResults()


local offset = {-0x50,-0x30,0x20}
local value_offset1 = -0x50
local value_offset2 = {0xB0}

local newValues = {325,1000,100}

local expected1 = {1}

local expected = {
360,365,370,375,380,385,390,395,
400,405,410,415,420,425,430,435,440,445,450,455,460,465,470,475,480,485,490,495,
500,505,510,515,520,525,530,535,540,545,550,555,560,565,570,575,580,585,590,595,600
}

-- ===== SEARCH =====
local searchValue = -1

gg.searchNumber(searchValue, gg.TYPE_DOUBLE)
local count = gg.getResults(1000)

if count == 0 then
    gg.alert("❌ រកមិនឃើញ searchValue")
    os.exit()
end

local results = gg.getResults(1000)
local valid = {}

for i, v in ipairs(results) do

    local base = v.address

    -- check expected1
    local check1 = gg.getValues({
        {address = base + value_offset1, flags = gg.TYPE_DOUBLE}
    })

    local ok1 = false
    if check1 and check1[1] then
        for _, e in ipairs(expected1) do
            if check1[1].value == e then
                ok1 = true
                break
            end
        end
    end

    -- check expected
    local ok2 = false

    for _, off in ipairs(value_offset2) do

        local check2 = gg.getValues({
            {address = base + off, flags = gg.TYPE_DOUBLE}
        })

        if check2 and check2[1] then
            for _, e in ipairs(expected) do
                if check2[1].value == e then
                    ok2 = true
                    break
                end
            end
        end

        if ok2 then break end
    end

    if ok1 and ok2 then
        table.insert(valid, v)
    end

end

-- ===== EDIT =====
if #valid == 0 then

    gg.alert("❌ មិនមានតម្លៃត្រូវគ្នា")

else

    gg.loadResults(valid)
    gg.alert("✅ រកឃើញ " .. #valid .. " លទ្ធផល! កំពុងកែប្រែ...")

    local set = {}

    for _, v in ipairs(valid) do
        for i = 1, #offset do
            table.insert(set, {
                address = v.address + offset[i],
                flags = gg.TYPE_DOUBLE,
                value = newValues[i]
            })
        end
    end

    gg.setValues(set)
    gg.toast("✅ កែប្រែបានជោគជ័យ!")

end

gg.clearResults()
