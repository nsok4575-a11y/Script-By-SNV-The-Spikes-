    gg.alert("❌ មិនមានតម្លៃត្រូវគ្នា")
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

         
