    gg.alert("❌ មិនមានតម្លៃត្រូវគ្នាru")
local datetime = os.date("%Y-%m-%d %H:%M:%S")
local v = gg.getTargetInfo().versionName

local title = "Script THE Spike Volleyball\n📌 Version: " .. v ..
              "\n📅 ថ្ងៃ ខែ ឆ្នាំ ម៉ោងប្រើប្រាស់៖ " .. datetime ..
              "\nScript The Spike GG by សុខ អែណាវ🇰🇭🇰🇭"
local start12 = gg.choice({
    
    "⚙️ ឈ្នះដោយស្វ័យប្រវត្តិ ",
            "⚙️ បន្ថែមពិន្ទុ ", 
    "⚙️ ប្តូកីឡាករ ",
        "⚙️ ប្ដូរស្គីនបាល់ ",
    "🚪 ចាក់ចេញ"
  }, nil, title)
if start12 == nil then return end
if start12 == 4 then
    gg.setRanges(gg.REGION_C_ALLOC)
gg.clearResults()

-- input skin
local input = gg.prompt(
    {"🔢 បញ្ចូលលេខ Skin [1;40]"}, 
    {[1] = "1"}, 
    {"number"}
)
if not input then
    start()
    return
end
local newValue1 = input[1]
-- offsets & values
local search_value = -4
local check_offset = 0x110
local write_offset = 0x110
local expected_value = {
1,2,3,4,5,6,7,8,9,10,
11,12,13,14,15,16,17,18,19,20,
21,22,23,24,25,26,27,28,29,30,
31,32,33,34,35,36,37,38,39,40
}

-- function check value in table
local function isValid(val)
    for _, v in ipairs(expected_value) do
        if v == val then
            return true
        end
    end
    return false
end

-- search
gg.searchNumber(search_value, gg.TYPE_DOUBLE)
local results = gg.getResults(1000)
local valid_results = {}

-- filter results
for i, v in ipairs(results) do
    local check_addr = v.address + check_offset
    
    local check_val = gg.getValues({
        {address = check_addr, flags = gg.TYPE_DOUBLE}
    })[1].value

    if isValid(check_val) then
        table.insert(valid_results, v)
    end
end
if #valid_results == 0 then
    gg.alert("❌ រកមិនឃើញ Address ត្រឹមត្រូវ")
    start()
    return
end
-- prepare write
local modified = {}
for _, v in ipairs(valid_results) do
    table.insert(modified, {
        address = v.address + write_offset,
        flags = gg.TYPE_DOUBLE, value = newValue1
    })
end
-- write value
gg.setValues(modified)
gg.toast("✅ Skin ត្រូវបានកែប្រែ")

-- lock value
while true do
    
    if gg.isVisible(true) then
        gg.setVisible(false)
        gg.toast("⛔ Lock Stopped")
        break
    end

    local current = gg.getValues(modified)
    local changed = false

    for i, v in ipairs(current) do
        if v.value ~= newValue1 then
            current[i].value = newValue1
            changed = true
        end
    end

    if changed then
        gg.setValues(current)
        gg.toast("🔒 តម្លៃត្រូវបានស្ដារឡើងវិញ")
    end

    gg.sleep(1000)

end

start()
end
if start12 == 1 then
    gg.setRanges(gg.REGION_OTHER)
    local OFFSET = 0x20
    local expected_values = {-1}

    
    gg.searchNumber("80", gg.TYPE_DOUBLE)

    local results = gg.getResults(1000)
    local valid_results = {}

    for _, v in ipairs(results) do
      local val = gg.getValues({
        {address = v.address + OFFSET, flags = gg.TYPE_DOUBLE}
      })[1].value

      for _, exp in ipairs(expected_values) do
        if val == exp then
          table.insert(valid_results, v)
          break
        end
      end
    end

    if #valid_results == 0 then
      gg.alert("❌ មិនមានតម្លៃត្រូវគ្នាទេ!\nបង្កើន Power ឬ Jump ≥ 5")
      return
    end

    local set = {}
    for _, v in ipairs(valid_results) do
      table.insert(set, {
        address = v.address + OFFSET,
        flags = gg.TYPE_DOUBLE,
        value = 1
      })
    end

    gg.setValues(set)
    gg.toast("✅ Auto Win ដំណើរការរួច")
  end
gg.clearResults()
-- ===== SAVE RESULT (global) =====
savedList = savedList or {}


------------------------------------
if start12 == 2 then
gg.setRanges(gg.REGION_C_ALLOC)

-- ===== CONFIG =====
local offset = {0x60, 0x50}
local value_offset1 = 0x60
local value_offset2 = {0x50}

local expected = {-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13}

-- ===== INPUT =====
local k2 = gg.prompt(
  {
    "បញ្ចូលលេខកីឡាករ\nខាងយើង [0;12]",
    "ខាងគេ[-1;0]"
  },
  nil,
  {"number","number"}
)

if not k2 then return end

local character = tonumber(k2[1])
local editValue = tonumber(k2[2])
if not character or character < -100 or character > 12 then
  gg.alert("❌ លេខកីឡាករ មិនត្រឹមត្រូវ")
  return
end

-- ===== SEARCH VALUE =====
local searchValue = 795364

-- ===== SEARCH (run only once) =====
if #savedList == 0 then
  gg.toast("🔍 កំពុងស្វែងរក...")

  gg.searchNumber(searchValue, gg.TYPE_DWORD)
  local results = gg.getResults(1000)
  local valid = {}

  for _, v in ipairs(results) do
    local base = v.address

    local v1 = gg.getValues({
      {address = base + value_offset1, flags = gg.TYPE_DOUBLE}
    })[1].value

    local ok1 = false
    for _, e in ipairs(expected) do
      if v1 == e then ok1 = true break end
    end

    local ok2 = false
    for _, o in ipairs(value_offset2) do
      local v2 = gg.getValues({
        {address = base + o, flags = gg.TYPE_DOUBLE}
      })[1].value

      for _, e in ipairs(expected) do
        if v2 == e then ok2 = true break end
      end
    end

    if ok1 and ok2 then
      table.insert(valid, v)
    end
  end

  savedList = valid
else
  gg.toast("⚡ ប្រើ address ចាស់")
end

-- ===== EDIT =====
if #savedList == 0 then
  gg.alert("❌ មិនមានតម្លៃត្រូវគ្នា")
else
  local set = {}
  for _, v in ipairs(savedList) do
    table.insert(set, {
      address = v.address + offset[1],
      flags = gg.TYPE_DOUBLE,
      value = character
    })
    table.insert(set, {
      address = v.address + offset[2],
      flags = gg.TYPE_DOUBLE,
      value = editValue
    })
  end


  gg.setValues(set)
  gg.toast("✅ កែប្រែរួចរាល់")
end
end
if start12 == 3 then
  gg.setRanges(gg.REGION_C_ALLOC)

  local Ball = gg.multiChoice(
    {"WS", "MB", "SE", "🔙 Back"},
    nil,
    title
  )

  if Ball == nil then
    start()
    return
  end

-- =====================================================================
-- 🏐 Mode 1 (WS)
-- =====================================================================
if Ball[1] then
  local offset = {-0x90,-0x50,-0xA0,-0x20,-0x60,-0x80,0x20}
  local value_offset1 = -0x90
  local value_offset2 = {-0x50}
  local value_offset3 = {-0xA0}

  local expected_value2 = {
    5,10,15,20,25,30,35,40,45,50,
    55,60,65,70,75,80,85,90,95
  }

  local expected_values = {
    WS = {
      1,5,8,10,13,16,21,24,27,30,33,36,39,42,45,
      49,50,53,56,59,62,65,68,71,75,79,82,85,
      88,91,94,98,101,104,107,109,111,112,115,
      158,159,162,164,166,170,174,177,181,184,
      187,190,193,198,203,205,207,210,212,217,
      220,222,224,228,229,232,235,240,242,245,
      246,248,251,254,257,259,262,264,267,271,
      275,281,284,288,289,291,294,299
    }
  }

  local k2 = gg.prompt({
    "🕵️‍♂️ បញ្ចូលថាមពលកីឡាករ (ស្វែងរក)WS",
    "1 Raul\n2 Nishikawa HS\n3 Ryhyeon\n4 Lucas\n5 Black Nishikawa\n6 Isabel\n7 Jeahyeon\n8 Siwoo Back\n9 Hongsi[1;9]",
    "💥 កម្លាំងវាយប្រហារ[50;1000]",
    "🦘 កម្លាំងលោត[50;200]"
  }, nil, {"number","number","number","number"})

  if k2 then
    local values = {
      ["1"]=332,["2"]=248,["3"]=225,["4"]=284,
      ["5"]=164,["6"]=245,["7"]=246,["8"]=325,["9"]=212
    }

    local values1 = {
      ["1"]=-1,["2"]=-1,["3"]=7,["4"]=-1,
      ["5"]=-1,["6"]=-1,["7"]=-1,["8"]=-1,["9"]=14
    }

    local searchValue = tonumber(k2[1])
    local character = tostring(k2[2])
    local editValue1 = tonumber(k2[3])
    local editValue2 = tonumber(k2[4])

    if not values[character] then
      gg.alert("❌ អ្នកបានបញ្ចូលលេខខុសសម្រាប់កីឡាករ!")
      gg.clearResults()
      return
    end

    local newValues = {
      values[character],
      editValue1,
      editValue2,
      5,
      40,
     700,
      values1[character]
    }

    gg.clearResults()
    gg.searchNumber(searchValue, gg.TYPE_DOUBLE)
    local results = gg.getResults(1000)
    local valid_results = {}

    for _, v in ipairs(results) do
      local base = v.address

      local v1 = gg.getValues({{address=base+value_offset1, flags=gg.TYPE_DOUBLE}})[1].value
      local m1=false
      for _,e in ipairs(expected_values.WS) do if v1==e then m1=true break end end
                local m2=false
      for _,o in ipairs(value_offset2) do
        local v2=gg.getValues({{address=base+o, flags=gg.TYPE_DOUBLE}})[1].value
        for _,e in ipairs(expected_value2) do if v2==e then m2=true break end end
        if m2 then break end
      end

      local m3=false
      for _,o in ipairs(value_offset3) do
        local v3=gg.getValues({{address=base+o, flags=gg.TYPE_DOUBLE}})[1].value
        for _,e in ipairs(expected_value2) do if v3==e then m3=true break end end
        if m3 then break end
      end

      if m1 and m2 and m3 then table.insert(valid_results, v) end
    end

    if #valid_results==0 then
      gg.alert("❌ មិនមានតម្លៃណាមួយត្រូវគ្នាទេ")
    else
      gg.loadResults(valid_results)
      local set={}
      for _,v in ipairs(valid_results) do
        for i=1,#offset do
          table.insert(set,{
            address=v.address+offset[i],
            flags=gg.TYPE_DOUBLE,
            value=newValues[i]
          })
        end
      end
      gg.setValues(set)
      gg.toast("✅ តម្លៃត្រូវបានកែប្រែរួច")
    end
  end
  gg.clearResults()
    end
