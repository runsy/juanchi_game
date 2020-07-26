dlg = {}

dlg.dialogues = {}

function dlg.register_dialogue(actor, dialogue)
	table.insert(dlg.dialogues, dialogue, actor)
end

function dlg.register_lines(dialogue, lines)
	local dialogue = {}
	dialogue.lines = {}
	for key, value in pairs(lines) do
		dialogue.lines[key] = value 
	end	
	return dialogue
end

function dlg.check_conditions(conditions)
	for id, condition in pairs(conditions) do
		
	end
end

function dlg.start_conversation(actor)
	local dialogue = dialogues["actor"]
	for id, line in pairs(dialogue) do
		local condition = false
		local line_conditions = line.conditions
		if line_conditions then
			condition = dlg.check_conditions(line_conditions)
		end
	end
end
