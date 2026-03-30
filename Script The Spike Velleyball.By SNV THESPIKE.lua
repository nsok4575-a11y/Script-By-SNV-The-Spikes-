
function start()

    

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
        flags = gg.TYPE_DOUBLE,
        value = newValue1
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
  -- ===== AUTO WIN =====
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
if Ball[2] then
local offset = {-0x100,-0xE0,-0x90,-0xF0,-0xC0,-0xA0,-0x70}
  local value_offset1 = -0x100
  local value_offset2 = {-0xE0}
  local value_offset3 = {-0x90}

local expected_value2 = {
  5,10,15,20,25,30,35,40,45,50,
  55,60,65,70,75,80,85,90,95
}
  local expected_values = {
    MB = {
      3,7,9,12,15,19,23,26,29,32,35,38,41,44,47,48,
      52,55,58,61,64,67,70,74,76,78,81,84,
      87,90,93,96,103,106,108,112,113,160,
      163,166,169,171,173,176,178,183,186,
      189,192,196,200,206,209,213,216,218,
      223,229,232,233,237,239,249,253,258,
      261,262,266,269,271,274,277,280,293,
      282,283,288,324
    }
  }

  local k2 = gg.prompt({
    "🕵️‍♂️ បញ្ចូលថាមពលកីឡាករ (ស្វែងរក)MB",
    "1 Sanghyeon\n2 Hari\n3 Claire\n4 Hanra\n5 Isabel[1;5]",
    "💥 កម្លាំងវាយប្រហារ[50;1000]",
    "🦘 កម្លាំងលោត[50;200]"
  }, nil, {"number", "number", "number", "number"})

  if k2 then
    local values = {
   
      ["1"] = 160,  -- Sanghyeon
      ["2"] = 282,  -- Hari
        ["3"] = 322,-- 
        ["4"] = 218,
        ["5"] = 245

   
    }
    local values1 = {
      ["1"] = -1, -- Raul
      ["2"] = -1,  -- Nishikawa HS
      ["3"] = 1,  -- Ryuhyeon
      ["4"] = -1,  -- Lucas
      ["5"] = -1,  -- Black Nishikawa
      ["6"] = -1, --Isabel
      ["7"] = -1, --Jeahyeon
      ["8"] = -1--Siwoo
}
    local searchValue = tonumber(k2[1])
    local character = tostring(k2[2])  
    local editValue1 = tonumber(k2[3])  
    local editValue2 = tonumber(k2[4])  

    if not values[character] then  
      gg.alert("❌ អ្នកបានបញ្ចូលលេខខុសសម្រាប់កីឡាករ!")  
      return  
    end  

    local newValues = {  
      values[character],  
      editValue1,  
      editValue2,  
      5,  
      editValue1,  
      editValue2  
    }  

    gg.clearResults()  
    gg.searchNumber(searchValue, gg.TYPE_DOUBLE)  
    local results = gg.getResults(1000)  
    local valid_results = {}  

    for _, v in ipairs(results) do  
      local base_address = v.address  
      local addr1 = base_address + value_offset1  
      local val1 = gg.getValues({{address = addr1, flags = gg.TYPE_DOUBLE}})[1].value  

      local match1 = false  
      for _, val in ipairs(expected_values.MB) do  
        if val1 == val then  
          match1 = true  
          break  
        end  
      end  

      local match2 = false  
      for _, offset2 in ipairs(value_offset2) do  
        local addr2 = base_address + offset2  
        local val2 = gg.getValues({{address = addr2, flags = gg.TYPE_DOUBLE}})[1].value  
        for _, exp2 in ipairs(expected_value2) do  
          if val2 == exp2 then  
            match2 = true  
            break  
          end  
        end  
        if match2 then break end

end  
      local match3 = false  
      for _, offset3 in ipairs(value_offset3) do  
        local addr3 = base_address + offset3  
        local val3 = gg.getValues({{address = addr3, flags = gg.TYPE_DOUBLE}})[1].value  
        for _, exp3 in ipairs(expected_value2) do  
          if val3 == exp3 then  
            match3 = true  
            break  
          end  
        end  
        if match3 then break end  
      end  

      if match1 and match2 and match3 then  
        table.insert(valid_results, v)  
      end  
    end  

    if #valid_results == 0 then  
      gg.alert("❌ មិនមានតម្លៃណាមួយត្រូវគ្នាទេ។អ្នកត្រូវដំឡើងកម្លាំងវេរប្រហារឬកម្លាំងលោតយ៉ាងហោចណាស់ 5")  
    else  
    gg.loadResults(valid_results)  
      gg.alert("✅ រកឃើញ " .. #valid_results .. " លទ្ធផល! កំពុងកែប្រែ...")  
      
      
      
      local modified = {}  
      for _, v in ipairs(valid_results) do  
        for j = 1, #offset do  
          table.insert(modified, {  
            address = v.address + offset[j],  
            flags = gg.TYPE_DOUBLE,  
            value = newValues[j]  
          })  
        end  
      end  
      gg.setValues(modified)  
      gg.toast("✅ តម្លៃត្រូវបានកែប្រែរួច")  
    end
  end
  gg.clearResults()  
  end
  if Ball[3] then
local offset = {-0x100,-0xE0,-0x90,-0xF0,-0xC0,-0xA0,-0x70}
  local value_offset1 = -0x100
  local value_offset2 = {-0xE0}
  local value_offset3 = {-0x90}
-- ✅ Expected values
local expected_value2 = {
  5,10,15,20,25,30,35,40,45,50,
  55,60,65,70,75,80,85,90,95
}
  
      local expected_values = {
    SE = {2,4,8,11,14,20,22,25,28,31
,34,37,40,43,47,51,54,57,60,63,66,69,
73,77,80,83,86,89,92,95,97,100,102,105,
110,115,118,123,157,161,165,168,172,175,
179,180,182,185,188,191,195,197,200,201,204
,208,211,215,214,219,221,230,231,234,236,241,250,252,
259,255,256,260,265,267,270,273,276,279,287,290,292
    } 
 }

  local k2 = gg.prompt({
    "🕵️‍♂️ បញ្ចូលថាមពលកីឡាករ (ស្វែងរក)SE",
    "1 Sara\n2 Zero\n3 Sif\n4 Ellio\n5 NN\n6 Lisia[1;6]",
    "💥 កម្លាំងវាយប្រហារ[50;1000]",
    "🦘 កម្លាំងលោត[50;200]"
  }, nil, {"number", "number", "number", "number"})

  if k2 then
    local values = {
      ["1"] = 230,  
      ["2"] = 286,
      ["3"] = 323,
      ["4"] = 252,
      ["5"] = 313,
      ["6"] = 40
    
    }

local values1 = {
      ["1"] = 8, -- Raul
      ["2"] = -1,  -- Nishikawa HS
      ["3"] = -1,  -- Ryuhyeon
      ["4"] = -1,  -- Lucas
      ["5"] = -1,  -- Black Nishikawa
      ["6"] = 13, --Isabel
      ["7"] = -1, --Jeahyeon
      ["8"] = -1--Siwoo
}
    local searchValue = tonumber(k2[1])
    local character = tostring(k2[2])  
    local editValue1 = tonumber(k2[3])  
    local editValue2 = tonumber(k2[4])  

    if not values[character] then  
      gg.alert("❌ អ្នកបានបញ្ចូលលេខខុសសម្រាប់កីឡាករ!")  
      return  
    end  

    local newValues = {  
      values[character],  
      editValue1,  
      editValue2,  
      5,  
      editValue1,  
      editValue2,
      values1[character]
    }  

    gg.clearResults()  
    gg.searchNumber(searchValue, gg.TYPE_DOUBLE)  
    local results = gg.getResults(1000)  
    local valid_results = {}  

    for _, v in ipairs(results) do  
      local base_address = v.address  
      local addr1 = base_address + value_offset1  
      local val1 = gg.getValues({{address = addr1, flags = gg.TYPE_DOUBLE}})[1].value  

      local match1 = false  
      for _, val in ipairs(expected_values.SE) do  
        if val1 == val then  
          match1 = true  
          break  
        end  
      end  

      local match2 = false  
      for _, offset2 in ipairs(value_offset2) do  
        local addr2 = base_address + offset2  
        local val2 = gg.getValues({{address = addr2, flags = gg.TYPE_DOUBLE}})[1].value  
        for _, exp2 in ipairs(expected_value2) do

if val2 == exp2 then  
            match2 = true  
            break  
          end  
        end  
        if match2 then break end  
      end  
      local match3 = false  
      for _, offset3 in ipairs(value_offset3) do  
        local addr3 = base_address + offset3  
        local val3 = gg.getValues({{address = addr3, flags = gg.TYPE_DOUBLE}})[1].value  
        for _, exp3 in ipairs(expected_value2) do  
          if val3 == exp3 then  
            match3 = true  
            break  
          end  
        end  
        if match3 then break end  
      end  

      if match1 and match2 and match3 then  
        table.insert(valid_results, v)  
      end  
    end  

    if #valid_results == 0 then  
      gg.alert("❌ មិនមានតម្លៃណាមួយត្រូវគ្នាទេ។អ្នកត្រូវដំឡើងកម្លាំងវេរប្រហារឬកម្លាំងលោតយ៉ាងហោចណាស់ 5")  
    else  
    gg.loadResults(valid_results)  
      gg.alert("✅ រកឃើញ " .. #valid_results .. " លទ្ធផល! កំពុងកែប្រែ...")  
      
      
      
      local modified = {}  
      for _, v in ipairs(valid_results) do  
        for j = 1, #offset do  
          table.insert(modified, {  
            address = v.address + offset[j],  
            flags = gg.TYPE_DOUBLE,  
            value = newValues[j]  
          })  
        end  
      end  
      gg.setValues(modified)  
      gg.toast("✅ តម្លៃត្រូវបានកែប្រែរួច")  
    end
    gg.clearResults()  
  end
  end
  
-- =====================================================================
-- 🔙 Back
-- =====================================================================
if Ball[4] then
  start()
end


end -- end start12 == 3
  if start12 == 5 then
    gg.alert("👋 ចាកចេញពី Script!")
    os.exit()
  end
end

while true do
  if gg.isVisible(true) then
    gg.setVisible(false)
    start()
  end
end    local base = v.address

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
