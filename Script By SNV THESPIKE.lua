GLOBAL VARIABLES
-- =========================================
local SAVE_FILE_ADDRESS =
    gg.EXT_STORAGE .. "/AUTO SERVE.txt"

local SAVE_FILE_OFFSET =
    gg.EXT_STORAGE .. "/KICK ENEMY.txt"

local SAVE_FILE_OFFSET1 =
    gg.EXT_STORAGE .. "/EDIT SCOR.txt"


os.remove(SAVE_FILE_ADDRESS)
os.remove(SAVE_FILE_OFFSET)
os.remove(SAVE_FILE_OFFSET1)
AUTO_SERVE = false
KICK_ENEMY = false

ORIGINAL_AUTO_VALUES = {}
ORIGINAL_KICK_VALUES = {}

selectedScore = nil

-- =========================================
-- NEXT MENU
-- 0 = MAIN MENU
-- 2 = EDIT SCORE
-- =========================================

NEXT_MENU = 0


-- =========================================
-- SAVE FILES
-- =========================================

local SAVE_FILE_ADDRESS =
    gg.EXT_STORAGE .. "/AUTO SERVE.txt"

local SAVE_FILE_OFFSET =
    gg.EXT_STORAGE .. "/KICK ENEMY.txt"

local SAVE_FILE_OFFSET1 =
    gg.EXT_STORAGE .. "/EDIT SCOR.txt"


-- =========================================
-- SEARCH SETTINGS
-- =========================================

local SEARCH_VALUE = "9999"

local OFFSET_1 = 0x2FCE0
local OFFSET_2 = 0x243B8


-- =========================================
-- LOAD ONE ADDRESS
-- =========================================

local function loadAddress(filePath)

    local file =
        io.open(filePath, "r")

    if not file then
        return nil
    end

    local line =
        file:read("*l")

    file:close()

    if line then
        return tonumber(line)
    end

    return nil
end


-- =========================================
-- SAVE ONE ADDRESS
-- =========================================

local function saveAddress(filePath, address)

    local file =
        io.open(filePath, "w")

    if not file then

        gg.alert(
            "មិនអាចរក្សាទុក Address បានទេ\n\n" ..
            filePath
        )

        return false
    end

    file:write(
        tostring(address) .. "\n"
    )

    file:close()

    return true
end


-- =========================================
-- LOAD SAVED ADDRESSES
-- =========================================

local savedAddress =
    loadAddress(
        SAVE_FILE_ADDRESS
    )

local savedOffsetAddress =
    loadAddress(
        SAVE_FILE_OFFSET
    )

local savedOffsetAddress1 =
    loadAddress(
        SAVE_FILE_OFFSET1
    )


-- =========================================
-- FIRST RUN SEARCH
-- =========================================

if savedAddress and
   savedOffsetAddress and
   savedOffsetAddress1 then

    gg.toast(
        "បាន Load Address ទាំង 3 រួចហើយ ✓"
    )

else

    gg.setVisible(false)

    gg.clearResults()

    gg.setRanges(
        gg.REGION_OTHER
    )

    gg.searchNumber(
        SEARCH_VALUE,
        gg.TYPE_DOUBLE
    )

    local results =
        gg.getResults(1000)


    -- =====================================
    -- CHECK RESULTS
    -- =====================================

    if #results < 2 then

        gg.setVisible(true)

        gg.alert(
            "រកឃើញ 9999 មិនដល់ 2 Results\n\n" ..
            "រកឃើញ: " ..
            #results
        )

        gg.clearResults()

        return
    end


    -- =====================================
    -- RESULT #2
    -- =====================================

    local target =
        results[2]

    local originalAddress =
        target.address


    -- =====================================
    -- OFFSET 1
    -- =====================================

    local offsetAddress1 =
        originalAddress + OFFSET_1


    -- =====================================
    -- OFFSET 2
    -- =====================================

    local offsetAddress2 =
        originalAddress + OFFSET_2


    -- =====================================
    -- SAVE AUTO SERVE
    -- =====================================

    if not saveAddress(
        SAVE_FILE_ADDRESS,
        originalAddress
    ) then

        gg.setVisible(true)
        gg.clearResults()

        return
    end


    -- =====================================
    -- SAVE KICK ENEMY
    -- =====================================

    if not saveAddress(
        SAVE_FILE_OFFSET,
        offsetAddress1
    ) then

        gg.setVisible(true)
        gg.clearResults()

        return
    end


    -- =====================================
    -- SAVE EDIT SCORE
    -- =====================================

    if not saveAddress(
        SAVE_FILE_OFFSET1,
        offsetAddress2
    ) then

        gg.setVisible(true)
        gg.clearResults()

        return
    end


    -- =====================================
    -- UPDATE
    -- =====================================

    savedAddress =
        originalAddress

    savedOffsetAddress =
        offsetAddress1

    savedOffsetAddress1 =
        offsetAddress2


    gg.clearResults()

    gg.setVisible(true)

    gg.toast(
        "បានរក្សាទុក Address ទាំង 3 រួចហើយ ✓"
    )

end


-- =========================================
-- GAME RANGE
-- =========================================

gg.setRanges(
    gg.REGION_OTHER
)


-- =========================================
-- AUTO SERVE
-- =========================================

function autoServe()

    gg.setRanges(
        gg.REGION_OTHER
    )

    local ZERO_OFFSET = 0x40
    local EDIT_OFFSET = -0x1530


    -- =====================================
    -- OFF → RESTORE
    -- =====================================

    if AUTO_SERVE == true then

        if #ORIGINAL_AUTO_VALUES == 0 then

            gg.alert(
                "មិនមានតម្លៃដើមសម្រាប់ Restore ទេ"
            )

            AUTO_SERVE = false

            return
        end


        gg.setValues(
            ORIGINAL_AUTO_VALUES
        )

        ORIGINAL_AUTO_VALUES = {}

        AUTO_SERVE = false

        gg.toast(
            "AUTO SERVE: បិទ ✓"
        )

        return
    end


    -- =====================================
    -- LOAD AUTO SERVE ADDRESS
    -- =====================================

    local address =
        loadAddress(
            SAVE_FILE_ADDRESS
        )


    if not address then

        gg.alert(
            "រកមិនឃើញ Address ក្នុង File\n\n" ..
            "AUTO SERVE.txt"
        )

        return
    end


    -- =====================================
    -- ORIGINAL VALUES
    -- =====================================

    ORIGINAL_AUTO_VALUES = {}


    local original1 =
        gg.getValues({

            {
                address =
                    address + ZERO_OFFSET,

                flags =
                    gg.TYPE_DOUBLE
            }

        })


    if original1[1] then

        table.insert(
            ORIGINAL_AUTO_VALUES,

            {
                address =
                    address + ZERO_OFFSET,

                flags =
                    gg.TYPE_DOUBLE,

                value =
                    original1[1].value
            }
        )

    end


    local original2 =
        gg.getValues({

            {
                address =
                    address + EDIT_OFFSET,

                flags =
                    gg.TYPE_DOUBLE
            }

        })


    if original2[1] then

        table.insert(
            ORIGINAL_AUTO_VALUES,

            {
                address =
                    address + EDIT_OFFSET,

                flags =
                    gg.TYPE_DOUBLE,

                value =
                    original2[1].value
            }
        )

    end


    -- =====================================
    -- APPLY
    -- =====================================

    gg.setValues({

        {
            address =
                address + ZERO_OFFSET,

            flags =
                gg.TYPE_DOUBLE,

            value = 0
        },

        {
            address =
                address + EDIT_OFFSET,

            flags =
                gg.TYPE_DOUBLE,

            value = 1
        }

    })


    AUTO_SERVE = true

    gg.toast(
        "AUTO SERVE: បើក ✓"
    )

end


-- =========================================
-- EDIT SCORE
-- =========================================

function editScore()

    gg.setRanges(
        gg.REGION_OTHER
    )


    -- =====================================
    -- ADDRESS OFFSET
    -- =====================================

    local CHECK_OFFSET = 0x60
    local EDIT_OFFSET = 0x240


    -- =====================================
    -- IMPORTANT
    -- READ EDIT SCOR.txt
    -- =====================================

    local file =
        io.open(
            SAVE_FILE_OFFSET1,
            "r"
        )


    if not file then

        gg.alert(
            "រកមិនឃើញ Address ក្នុង File\n\n" ..
            "EDIT SCOR.txt"
        )

        return
    end


    -- =====================================
    -- LOAD ADDRESSES
    -- =====================================

    local saved = {}


    for line in file:lines() do

        local address =
            tonumber(line)

        if address then

            table.insert(
                saved,
                address
            )

        end

    end


    file:close()


    -- =====================================
    -- CHECK ADDRESS
    -- =====================================

    if #saved == 0 then

        gg.alert(
            "EDIT SCOR.txt មិនមាន Address ទេ"
        )

        return
    end


    -- =====================================
    -- DEFAULT SCORE
    -- =====================================

    if selectedScore == nil then

        selectedScore = 0

    end


    -- =====================================
    -- SCORE MENU
    -- =====================================

    local choices = {}


    for i = 1, 15 do

        if selectedScore == i then

            table.insert(
                choices,
                "Scor " ..
                i ..
                " ✓"
            )

        else

            table.insert(
                choices,
                "Scor " ..
                i
            )

        end

    end


    -- =====================================
    -- BACK
    -- =====================================

    table.insert(
        choices,
        "Back"
    )


    -- =====================================
    -- SHOW MENU
    -- =====================================

    local selected =
        gg.choice(
            choices,
            nil,
            "EDIT SCOR"
        )


    -- =====================================
    -- CANCEL
    -- =====================================

    if selected == nil then

        NEXT_MENU = 2

        return
    end


    -- =====================================
    -- BACK
    -- =====================================

    if selected == 16 then

        NEXT_MENU = 0

        return
    end


    -- =====================================
    -- SAVE SCORE
    -- =====================================

    selectedScore =
        selected


    local newValue =
        selectedScore


    -- =====================================
    -- KEEP EDIT SCORE
    -- =====================================

    NEXT_MENU = 2


    -- =====================================
    -- CREATE EDIT LIST
    -- =====================================

    local editList = {}


    for _, address in ipairs(saved) do


        -- =================================
        -- CHECK OFFSET
        -- =================================

        table.insert(
            editList,

            {
                address =
                    address + CHECK_OFFSET,

                flags =
                    gg.TYPE_DOUBLE,

                value =
                    newValue
            }
        )


        -- =================================
        -- EDIT OFFSET
        -- =================================

        table.insert(
            editList,

            {
                address =
                    address + EDIT_OFFSET,

                flags =
                    gg.TYPE_DOUBLE,

                value = 0
            }
        )

    end


    -- =====================================
    -- APPLY
    -- =====================================

    if #editList > 0 then

        gg.setValues(
            editList
        )

        gg.toast(
            "បានកែ Scor ជា " ..
            newValue ..
            " ✓"
        )

    else

        gg.alert(
            "មិនមាន Address សម្រាប់កែទេ"
        )

    end

end


-- =========================================
-- KICK ENEMY
-- =========================================

function kickEnemy()

    gg.setRanges(
        gg.REGION_OTHER
    )


    local CHECK_OFFSET = -0x10
    local EDIT_OFFSET = -0x220


    -- =====================================
    -- OFF → RESTORE
    -- =====================================

    if KICK_ENEMY == true then

        if #ORIGINAL_KICK_VALUES == 0 then

            gg.alert(
                "មិនមានតម្លៃដើមសម្រាប់ Restore ទេ"
            )

            KICK_ENEMY = false

            return
        end


        gg.setValues(
            ORIGINAL_KICK_VALUES
        )

        ORIGINAL_KICK_VALUES = {}

        KICK_ENEMY = false

        gg.toast(
            "KICK ENEMY: បិទ ✓"
        )

        return
    end


    -- =====================================
    -- LOAD KICK ENEMY ADDRESS
    -- =====================================

    local file =
        io.open(
            SAVE_FILE_OFFSET,
            "r"
        )


    if not file then

        gg.alert(
            "រកមិនឃើញ Address ក្នុង File\n\n" ..
            "KICK ENEMY.txt"
        )

        return
    end


    local saved = {}


    for line in file:lines() do

        local address =
            tonumber(line)

        if address then

            table.insert(
                saved,
                address
            )

        end

    end


    file:close()


    if #saved == 0 then

        gg.alert(
            "KICK ENEMY.txt មិនមាន Address ទេ"
        )

        return
    end


    -- =====================================
    -- ORIGINAL VALUES
    -- =====================================

    ORIGINAL_KICK_VALUES = {}


    for _, address in ipairs(saved) do

        local original1 =
            gg.getValues({

                {
                    address =
                        address + CHECK_OFFSET,

                    flags =
                        gg.TYPE_DOUBLE
                }

            })


        if original1[1] then

            table.insert(
                ORIGINAL_KICK_VALUES,

                {
                    address =
                        address + CHECK_OFFSET,

                    flags =
                        gg.TYPE_DOUBLE,

                    value =
                        original1[1].value
                }
            )

        end


        local original2 =
            gg.getValues({

                {
                    address =
                        address + EDIT_OFFSET,

                    flags =
                        gg.TYPE_DOUBLE
                }

            })


        if original2[1] then

            table.insert(
                ORIGINAL_KICK_VALUES,

                {
                    address =
                        address + EDIT_OFFSET,

                    flags =
                        gg.TYPE_DOUBLE,

                    value =
                        original2[1].value
                }
            )

        end

    end


    -- =====================================
    -- APPLY KICK ENEMY
    -- =====================================

    local editList = {}


    for _, address in ipairs(saved) do

        table.insert(
            editList,

            {
                address =
                    address + CHECK_OFFSET,

                flags =
                    gg.TYPE_DOUBLE,

                value = 0
            }
        )


        table.insert(
            editList,

            {
                address =
                    address + EDIT_OFFSET,

                flags =
                    gg.TYPE_DOUBLE,

                value = 1
            }
        )

    end


    if #editList > 0 then

        gg.setValues(
            editList
        )

        KICK_ENEMY = true

        gg.toast(
            "KICK ENEMY: បើក ✓"
        )

    else

        gg.alert(
            "មិនមាន Address សម្រាប់កែទេ"
        )

    end

end


-- =========================================
-- MAIN MENU
-- =========================================

function start()


    -- =====================================
    -- AUTO TEXT
    -- =====================================

    local AUTO_TEXT

    if AUTO_SERVE then

        AUTO_TEXT =
            "⚙️ AUTO SERVE ✓"

    else

        AUTO_TEXT =
            "⚙️ AUTO SERVE"

    end


    -- =====================================
    -- KICK TEXT
    -- =====================================

    local KICK_TEXT

    if KICK_ENEMY then

        KICK_TEXT =
            "⚙️ KICK ENEMY ✓"

    else

        KICK_TEXT =
            "⚙️ KICK ENEMY"

    end


    -- =====================================
    -- MAIN MENU
    -- =====================================

    local start12 =
        gg.choice({

            AUTO_TEXT,

            "⚙️ EDIT SCOR",

            KICK_TEXT,

            "EXIT"

        }, nil, "MAIN MENU")


    if start12 == nil then

        return
    end


    -- =====================================
    -- MENU 1
    -- =====================================

    if start12 == 1 then

        autoServe()

        return
    end


    -- =====================================
    -- MENU 2
    -- EDIT SCORE
    -- =====================================

    if start12 == 2 then

        NEXT_MENU = 2

        editScore()

        return
    end


    -- =====================================
    -- MENU 3
    -- KICK ENEMY
    -- =====================================

    if start12 == 3 then

        kickEnemy()

        return
    end


    -- =====================================
    -- EXIT
    -- =====================================

    if start12 == 4 then

        os.exit()

    end

end


-- =========================================
-- MAIN LOOP
-- =========================================

while true do

    if gg.isVisible(true) then

        gg.setVisible(false)


        -- =================================
        -- EDIT SCORE DIRECT MODE
        -- =================================

        if NEXT_MENU == 2 then

            editScore()

        else

            start()

        end

    end

    gg.sleep(100)

end
