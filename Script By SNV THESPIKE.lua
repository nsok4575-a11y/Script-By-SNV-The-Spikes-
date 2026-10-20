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
នេះជាអត្ថបទបើសិនជាអាចអ្នកក៏អាចកែអត្ថបទនេះឲ្យត្រូវតាមទម្រង់ដែរ
