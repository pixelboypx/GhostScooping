
player_class = {
    type = "", id = nil,
    Position = 0,
    character = 0,
    character_dt = 0,
    selectNum = 1,
    movedt = 0,
    state = 1,
    KeyConfig = {1, 2, 3, 4}
}

player_object = {}

function addPlayer(__type, __id, __Position)
    insertTable = {}

    insertTable.type = __type
    insertTable.id = __id
    insertTable.Position = __Position
    insertTable.character = __Position
    insertTable.character_dt = 0
    insertTable.selectNum = 1
    insertTable.movedt = 0
    insertTable.state = 1
    insertTable.KeyConfig = {1, 2, 3, 4}

    table.insert(player_object, insertTable)
end