/mob/living/carbon/monkey/punpun //except for a few special persistence features, pun pun is just a normal monkey
	name = "Pun Pun" //C A N O N
	unique_name = 0
	var/ancestor_name
	var/ancestor_chain = 1
	var/relic_hat	//Note: these two are paths
	var/relic_mask
	var/memory_saved = 0
	var/list/pet_monkey_names = list("Pun Pun", "Bubbles", "Mojo", "George", "Darwin", "Aldo", "Caeser", "Kanzi", "Kong", "Terk", "Grodd", "Mala", "Bojangles", "Coco", "Able", "Baker", "Scatter", "Norbit", "Travis")
	var/list/rare_pet_monkey_names = list("Professor Bobo", "Deempisi's Revenge", "Furious George", "King Louie", "Dr. Zaius", "Jimmy Rustles", "Dinner", "Lanky")

/mob/living/carbon/monkey/punpun/Initialize()
	Read_Memory()
	if(ancestor_name)
		name = ancestor_name
		if(ancestor_chain > 1)
			name += " \Roman[ancestor_chain]"
	else
		if(prob(5))
			name = pick(rare_pet_monkey_names)
		else
			name = pick(pet_monkey_names)
		gender = pick(MALE, FEMALE)
	..()

	//These have to be after the parent new to ensure that the monkey
	//bodyparts are actually created before we try to equip things to 
	//those slots
	if(relic_hat)
		equip_to_slot_or_del(new relic_hat, slot_head)
	if(relic_mask)
		equip_to_slot_or_del(new relic_mask, slot_wear_mask)

/mob/living/carbon/monkey/punpun/Life()
	if(SSticker.current_state == GAME_STATE_FINISHED && !memory_saved)
		Write_Memory(0)
	..()

/mob/living/carbon/monkey/punpun/death(gibbed)
	if(!memory_saved || gibbed)
		Write_Memory(1,gibbed)
	..()

/mob/living/carbon/monkey/punpun/proc/Read_Memory()
	var/savefile/S = new /savefile("data/npc_saves/Punpun.sav")
	S["ancestor_name"] 		>> ancestor_name
	S["ancestor_chain"]		>> ancestor_chain
	S["relic_hat"]			>> relic_hat
	S["relic_mask"]			>> relic_mask

/mob/living/carbon/monkey/punpun/proc/Write_Memory(dead, gibbed)
	var/savefile/S = new /savefile("data/npc_saves/Punpun.sav")
	if(gibbed)
		WRITE_FILE(S["ancestor_name"], null)
		WRITE_FILE(S["ancestor_chain"], 1)
		WRITE_FILE(S["relic_hat"], null)
		WRITE_FILE(S["relic_mask"], null)
		return
	if(dead)
		WRITE_FILE(S["ancestor_name"], ancestor_name)
		WRITE_FILE(S["ancestor_chain"], ancestor_chain + 1)
	if(!ancestor_name)	//new monkey name this round
		WRITE_FILE(S["ancestor_name"], name)
	if(head)
		WRITE_FILE(S["relic_hat"], head.type)
	else
		WRITE_FILE(S["relic_hat"], null)
	if(wear_mask)
		WRITE_FILE(S["relic_mask"], wear_mask.type)
	else
		WRITE_FILE(S["relic_mask"], null)
	if(!dead)
		memory_saved = 1
