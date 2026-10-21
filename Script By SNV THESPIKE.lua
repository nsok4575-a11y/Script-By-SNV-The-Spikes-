    if selectedScore == nil then

        selectedScore = 15

end
local EDIT_OFFSET = 0x60
local editList = {}

for _, address in ipairs(saved) do
    table.insert(editList, {
        address = address + EDIT_OFFSET,
        flags = gg.TYPE_DOUBLE,
        value = selectedScore
    })
end

if #editList > 0 then
    gg.setValues(editList)
    gg.toast("បានកំណត់តម្លៃជា " .. selectedScore)
else
    gg.alert("មិនមាន Address សម្រាប់កែទេ")
end
