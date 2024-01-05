#PUNISHGUI.SK

#--OPTIONS--

options:
	pm: &4No permission.
	prefix: &b&lABUNDANT &8•
	punishprefix: &4&lPUNISH &8•
	lightmute1: 5 minutes
	lightmute2: 1 hour
	lightmute3: 3 hours
	lightmute4: 6 hours
	lightmute5: 1 day
	mediummute1: 3 hours
	mediummute2: 12 hours
	mediummute3: 1 day
	mediummute4: 3 days
	highmute1: 3 days
	highmute2: 7 days
	highmute3: PERM
	lightban1: 5 minutes
	lightban2: 3 hours
	lightban3: 6 hours
	lightban4: 1 day
	mediumban1: 1 day
	mediumban2: 3 days
	mediumban3: 7 days
	highban1: 7 days
	highban2: 30 days
	highban3: PERM

	#discord logging options
	botName: Abundant
	punishLog: 853667906415231017

#--COMMANDS--

command /punish [<offline player>]:
	permission: skript.mod.punish
	permission message: {@pm}
	trigger:
		if arg-1 is set:
			punishMainMenu(player, arg-1)
		else:
			error(player, "You must specify a player to punish!")

#--EVENTS--

on load:
	set {lightmute::*} to "{@lightmute1}", "{@lightmute2}", "{@lightmute3}", "{@lightmute4}" and "{@lightmute5}"
	set {mediummute::*} to "{@mediummute1}", "{@mediummute2}", "{@mediummute3}" and "{@mediummute4}"
	set {highmute::*} to "{@highmute1}", "{@highmute2}", and "{@highmute3}"
	set {lightban::*} to "{@lightban1}", "{@lightban2}", "{@lightban3}" and "{@lightban4}"
	set {mediumban::*} to "{@mediumban1}", "{@mediumban2}", and "{@mediumban3}"
	set {highban::*} to "{@highban1}", "{@highban2}", and "{@highban3}"

#--FUNCTIONS--

function punishMainMenu(mod: player, punished: offline player):
	set {_mu} to uuid of {_mod}
	set {_pu} to uuid of {_punished}
	play sound "entity.chicken.egg" at pitch 0 to {_mod}
	create a gui with virtual chest inventory with size 5 named "Punishment Main Menu":
		make gui slot (integers between 0 and 44) with light gray stained glass pane named "&1"
		make gui slot (integers between 0 and 9), 17, 18, 26, 27 and (integers between 35 and 44) with black stained glass pane named "&1"
		make gui slot 4 with ({_punished}'s head) named "&7Punishing &b%{_punished}%"
		make gui slot 44 with barrier named "&4Close Menu":
			close {_mod}'s inventory
			play sound "entity.chicken.egg" at pitch 0 to {_mod}
		make gui slot 20 with red shulker box named "&fPunish" with lore "", "&8• &7Click &bhere &7to" and "&7punish &f%{_punished}%!":
			punishPunishMenu({_mod}, {_punished})
		make gui slot 22 with compass named "&fView Offenses" with lore "", "&8• &7Click &bhere &7to view" and "&f%{_punished}%&f's &7offenses!":
			punishViewOffensesMenu({_mod}, {_punished})
		make gui slot 24 with golden apple named "&fPardon" with lore "", "&8• &7Click &bhere &7to" and "&7pardon &f%{_punished}%!":
			punishPardonMenu({_mod}, {_punished})
	open the last gui to {_mod}

function punishPunishMenu(mod: player, punished: offline player):
	play sound "entity.chicken.egg" at pitch 0 to {_mod}
	create a gui with virtual chest inventory with size 5 named "Punishment Selection":
		make gui slot (integers between 0 and 44) with light gray stained glass pane named "&1"
		make gui slot (integers between 0 and 9), 17, 18, 26, 27 and (integers between 35 and 44) with black stained glass pane named "&1"
		make gui slot 4 with ({_punished}'s head) named "&7Punishing &b%{_punished}%"
		make gui slot 44 with barrier named "&4Back":
			punishMainMenu({_mod}, {_punished})
		make gui slot 20 with red concrete named "&fBan" with lore "", "&8• &7Click &bhere &7to" and "&7ban &f%{_punished}%!":
			punishBanMenu({_mod}, {_punished})
		make gui slot 22 with dispenser named "&fMute" with lore "", "&8• &7Click &bhere &7to" and "&7mute &f%{_punished}%!":
			punishMuteMenu({_mod}, {_punished})
		make gui slot 24 with stick named "&fOther" with lore "", "&8• &7Click &bhere &7to punish" and "&f%{_punished}% &7in another way!":
			punishOtherPunishMenu({_mod}, {_punished})
	open the last gui to {_mod}

function punishMuteMenu(mod: player, punished: offline player):
	play sound "entity.chicken.egg" at pitch 0 to {_mod}
	create a gui with virtual chest inventory with size 5 named "Mute Offense Selection":
		make gui slot (integers between 0 and 44) with light gray stained glass pane named "&1"
		make gui slot (integers between 0 and 9), 17, 18, 26, 27 and (integers between 35 and 44) with black stained glass pane named "&1"
		make gui slot 4 with ({_punished}'s head) named "&7Punishing &b%{_punished}%"
		make gui slot 44 with barrier named "&4Back":
			punishPunishMenu({_mod}, {_punished})
		make gui slot 20 with lime concrete named "&fLight Offense" with lore "", "&8• &7Examples of light", "&7offenses are:", "", "&8• &7Spamming", "&8• &7Flooding", "&8• &7Excessive Capitalization", "&8• &7Speaking in a foreign language" and "&8• &7Light Swearing":
			punishSelectReasonMenu({_mod}, {_punished}, "mute", "light")
		make gui slot 22 with yellow concrete named "&fMedium Offense" with lore "", "&8• &7Examples of medium", "&7offenses are:", "", "&8• &7NSFW", "&8• &7Toxicity", "&8• &7Impersonation", "&8• &7Scamming" and "&8• &7Rough Swearing":
			punishSelectReasonMenu({_mod}, {_punished}, "mute", "medium")
		make gui slot 24 with red concrete named "&fHigh Offense" with lore "", "&8• &7Examples of high", "&7offenses are:", "", "&8• &7Discrimination", "&8• &7Posting Malicious Links / Files", "&8• &7Advertising" and "&8• &7Suicidal Encouragement":
			punishSelectReasonMenu({_mod}, {_punished}, "mute", "high")
	open the last gui to {_mod}

function punishBanMenu(mod: player, punished: offline player):
	play sound "entity.chicken.egg" at pitch 0 to {_mod}
	create a gui with virtual chest inventory with size 5 named "Ban Offense Selection":
		make gui slot (integers between 0 and 44) with light gray stained glass pane named "&1"
		make gui slot (integers between 0 and 9), 17, 18, 26, 27 and (integers between 35 and 44) with black stained glass pane named "&1"
		make gui slot 4 with ({_punished}'s head) named "&7Punishing &b%{_punished}%"
		make gui slot 44 with barrier named "&4Back":
			punishPunishMenu({_mod}, {_punished})
		make gui slot 20 with lime concrete named "&fLight Offense" with lore "", "&8• &7Examples of light", "&7offenses are:", "", "&8• &7Constant combat logging" and "&8• &7Faking Blacklisted Modifications":
			punishSelectReasonMenu({_mod}, {_punished}, "ban", "light")
		make gui slot 22 with yellow concrete named "&fMedium Offense" with lore "", "&8• &7Examples of medium", "&7offenses are:", "", "&8• &7Bug / Glitch Abuse" and "&8• &7":
			punishSelectReasonMenu({_mod}, {_punished}, "ban", "medium")
		make gui slot 24 with red concrete named "&fHigh Offense" with lore "", "&8• &7Examples of high", "&7offenses are:", "", "&8• &7Using Blacklisted Modifications" and "&8• &7Refusing a screenshare request":
			punishSelectReasonMenu({_mod}, {_punished}, "ban", "high")
	open the last gui to {_mod}

function punishOtherPunishMenu(mod: player, punished: offline player):
	set {_mu} to uuid of {_mod}
	set {_pu} to uuid of {_punished}
	play sound "entity.chicken.egg" at pitch 0 to {_mod}
	create a gui with virtual chest inventory with size 5 named "Other Offense Selection":
		make gui slot (integers between 0 and 44) with light gray stained glass pane named "&1"
		make gui slot (integers between 0 and 9), 17, 18, 26, 27 and (integers between 35 and 44) with black stained glass pane named "&1"
		make gui slot 4 with ({_punished}'s head) named "&7Punishing &b%{_punished}%"
		make gui slot 44 with barrier named "&4Back":
			punishPunishMenu({_mod}, {_punished})
		make gui slot 21 with redstone comparator named "&fIP-Ban" with lore "", "&8• &7Use this in-case of a bot" and "&7attack or similar situation.":
			banip({_punished}'s IP, {_mod}, {_perm}, "The ban hammer has spoken.")
			send "%nl%{@punishprefix} &c%{_punished}% &7has been &cpermanently ip-banned!%nl%" to all players
			play sound "block.note_block.pling" at pitch 0 to all players
			set {_id} to genCode(30)
			add {_id} to {log::mypunishments::ids::%{_pu}%::*}
			add {_id} to {log::mymoderations::ids::%{_mu}%::*}
			set {log::punish::punishtype::%{_id}%} to "IP-Ban"
			set {log::punish::mod::%{_id}%} to {_mod}
			set {log::punish::punished::%{_id}%} to {_punished}
			set {log::punish::reason::%{_id}%} to "Unknown"
			set {log::punish::offensetype::%{_id}%} to "High"
			set {log::punish::offensenum::%{_id}%} to 1
			set {log::punish::date::%{_id}%} to now
			set {log::punish::length::%{_id}%} to "forever"
		make gui slot 23 with red concrete named "&fEmergency Ban" with lore "", "&8• &7Use this in-case of an" and "&7emergency or dire situation.":
			ban({_punished}, {_mod}, {_perm}, "The ban hammer has spoken.")
			send "%nl%{@punishprefix} &c%{_punished}% &7has been &cpermanently banned!%nl%" to all players
			play sound "block.note_block.pling" at pitch 0 to all players
			set {_id} to genCode(30)
			add {_id} to {log::mypunishments::ids::%{_pu}%::*}
			add {_id} to {log::mymoderations::ids::%{_mu}%::*}
			set {log::punish::punishtype::%{_id}%} to "Ban"
			set {log::punish::mod::%{_id}%} to {_mod}
			set {log::punish::punished::%{_id}%} to {_punished}
			set {log::punish::reason::%{_id}%} to "Unknown"
			set {log::punish::offensetype::%{_id}%} to "High"
			set {log::punish::offensenum::%{_id}%} to 1
			set {log::punish::date::%{_id}%} to now
			set {log::punish::length::%{_id}%} to "forever"
	open the last gui to {_mod}

function punishViewOffensesMenu(mod: player, punished: offline player):
	play sound "entity.chicken.egg" at pitch 0 to {_mod}
	set {_pu} to uuid of {_punished}
	create a gui with virtual chest inventory with size 5 named "View Offenses":
		make gui slot (integers between 0 and 44) with light gray stained glass pane named "&1"
		make gui slot (integers between 0 and 9), 17, 18, 26, 27 and (integers between 35 and 44) with black stained glass pane named "&1"
		make gui slot 4 with ({_punished}'s head) named "&7Viewing &b%{_punished}%"
		make gui slot 44 with barrier named "&4Back":
			punishMainMenu({_mod}, {_punished})
		loop {log::mypunishments::ids::%{_pu}%::*}:
			make gui slot getClickFromNum28(loop-index parsed as a number) with paper named "&f%{log::punish::offensetype::%loop-value%}% &f%{log::punish::punishtype::%loop-value%}% &8[&c##&l%{log::punish::offensenum::%loop-value%}%&8]" with lore "", "&7Moderator: &f%{log::punish::mod::%loop-value%}%", "&7Length: &f%{log::punish::length::%loop-value%}%", "&7Reason: &f%{log::punish::reason::%loop-value%}%", "&7Date: &f%{log::punish::date::%loop-value%}% &fGMT", "", "&c&l&nCLICK TO REMOVE", "" and "&8%loop-value%":
				if {_mod} has permission "skript.mod.punishment.delete":
					set {_id} to line 9 of event-item's lore
					set {_punishment.mod} to line 2 of event-item's lore
					replace all "&7Moderator: &f" in {_punishment.mod} with ""
					set {_punishment.mod} to {_punishment.mod} parsed as a player
					set {_mu} to uuid of {_punishment.mod}
					replace all "&8" in {_id} with ""
					remove {_id} from {log::mypunishments::ids::%{_pu}%::*}
					remove {_id} from {log::mymoderations::ids::%{_mu}%::*}
					delete {log::punish::punishtype::%{_id}%}
					delete {log::punish::mod::%{_id}%}
					delete {log::punish::punished::%{_id}%}
					delete {log::punish::reason::%{_id}%}
					delete {log::punish::offensetype::%{_id}%}
					delete {log::punish::offensenum::%{_id}%}
					delete {log::punish::date::%{_id}%}
					delete {log::punish::length::%{_id}%}
					send "{@prefix} &7You successfully deleted the punishment with ID &b%{_id}%&7!" to {_mod}
					punishViewOffensesMenu({_mod}, {_punished})
				else:
					error({_mod}, "You do not have permission to do this!")
	open the last gui to {_mod}

function punishPardonMenu(mod: player, punished: offline player):
	play sound "entity.chicken.egg" at pitch 0 to {_mod}
	set {_pu} to uuid of {_punished}
	create a gui with virtual chest inventory with size 5 named "Pardon Selection":
		make gui slot (integers between 0 and 44) with light gray stained glass pane named "&1"
		make gui slot (integers between 0 and 9), 17, 18, 26, 27 and (integers between 35 and 44) with black stained glass pane named "&1"
		make gui slot 4 with ({_punished}'s head) named "&7Punishing &b%{_punished}%"
		make gui slot 44 with barrier named "&4Back":
			punishMainMenu({_mod}, {_punished})
		make gui slot 20 with {item::noflagshovel} with lore "", "&8• &7Click &bhere &7to remove" and "&f%{_punished}%&f's &7offense(s)":
			play sound "entity.chicken.egg" at pitch 0 to {_mod}
			punishRemoveOffensesMenu({_mod}, {_punished})
		make gui slot 22 with dispenser named "&fUnmute" with lore "" and "&8• &7Click &bhere &7to unmute &f%{_punished}%!":
			if {punish::mute::status::%{_pu}%} is set:
				unmute({_punished})
				play sound "entity.arrow.hit_player" at pitch 2 to {_mod}
				send "{@prefix} &7You successfully un-muted &f%{_punished}%!" to {_mod}
			else:
				error({_mod}, "This player is not currently muted!")
		make gui slot 24 with lime concrete named "&fUnban" with lore "" and "&8• &7Click &bhere &7to unban &f%{_punished}%!":
			if {punish::ban::status::%{_pu}%} is set:
				unban({_punished})
				play sound "entity.arrow.hit_player" at pitch 2 to {_mod}
				send "{@prefix} &7You successfully un-banned &f%{_punished}%!" to {_mod}
			else:
				error({_mod}, "This player is not currently banned!")
	open the last gui to {_mod}

function punishRemoveOffensesMenu(mod: player, punished: offline player):
	set {_pu} to uuid of {_punished}
	create a gui with virtual chest inventory with size 5 named "Remove Offenses":
		make gui slot (integers between 0 and 44) with light gray stained glass pane named "&1"
		make gui slot (integers between 0 and 9), 17, 18, 26, 27 and (integers between 35 and 44) with black stained glass pane named "&1"
		make gui slot 4 with ({_punished}'s head) named "&7Punishing &b%{_punished}%"
		make gui slot 44 with barrier named "&4Back":
			punishPardonMenu({_mod}, {_punished})
		make gui slot 10 with lime concrete named "&fRemove Light Mute &8| &f##&l%{log::offenses::lightmute::%{_pu}%} ? 0%" with lore "" and "&8• &7Click to remove":
			subtract 1 from {log::offenses::lightmute::%{_pu}%} if {log::offenses::lightmute::%{_pu}%} > 0
			punishRemoveOffensesMenu({_mod}, {_punished})
		make gui slot 13 with yellow concrete named "&fRemove Medium Mute &8| &f##&l%{log::offenses::mediummute::%{_pu}%} ? 0%" with lore "" and "&8• &7Click to remove":
			subtract 1 from {log::offenses::mediummute::%{_pu}%} if {log::offenses::mediummute::%{_pu}%} > 0
			punishRemoveOffensesMenu({_mod}, {_punished})
		make gui slot 16 with red concrete named "&fRemove High Mute &8| &f##&l%{log::offenses::highmute::%{_pu}%} ? 0%" with lore "" and "&8• &7Click to remove":
			subtract 1 from {log::offenses::highmute::%{_pu}%} if {log::offenses::highmute::%{_pu}%} > 0
			punishRemoveOffensesMenu({_mod}, {_punished})
		make gui slot 28 with lime concrete powder named "&fRemove Light Ban &8| &f##&l%{log::offenses::lightban::%{_pu}%} ? 0%" with lore "" and "&8• &7Click to remove":
			subtract 1 from {log::offenses::lightban::%{_pu}%} if {log::offenses::lightban::%{_pu}%} > 0
			punishRemoveOffensesMenu({_mod}, {_punished})
		make gui slot 31 with yellow concrete powder named "&fRemove Medium Ban &8| &f##&l%{log::offenses::mediumban::%{_pu}%} ? 0%" with lore "" and "&8• &7Click to remove":
			subtract 1 from {log::offenses::mediumban::%{_pu}%} if {log::offenses::mediumban::%{_pu}%} > 0
			punishRemoveOffensesMenu({_mod}, {_punished})
		make gui slot 34 with red concrete powder named "&fRemove High Ban &8| &f##&l%{log::offenses::highban::%{_pu}%} ? 0%" with lore "" and "&8• &7Click to remove":
			subtract 1 from {log::offenses::highban::%{_pu}%} if {log::offenses::highban::%{_pu}%} > 0
			punishRemoveOffensesMenu({_mod}, {_punished})
	open the last gui to {_mod}

function punishSelectReasonMenu(mod: player, punished: offline player, punishtype: text, offensetype: text):
	set {_u} to uuid of {_mod}
	set {mod::%{_u}%} to {_mod}
	set {punished::%{_u}%} to {_punished}
	set {punishtype::%{_u}%} to {_punishtype}
	set {offensetype::%{_u}%} to {_offensetype}
	open an anvil gui named "Type the reason" to {_mod} with lime concrete named "&f" with lore "&fType the reason above!", "" and "&8• &7Click the result to confirm", air, and air:
		if clicked raw slot is 0 or 1 or 2:
			cancel event
		if clicked raw slot is 2:
			set {_id} to genCode(30)
			set {_u} to uuid of event-player
			set {_mod} to {mod::%{_u}%}
			set {_punished} to {punished::%{_u}%}
			set {_punishtype} to {punishtype::%{_u}%}
			set {_offensetype} to {offensetype::%{_u}%}
			set {_pu} to uuid of {_punished}
			delete {mod::%{_u}%}
			delete {punished::%{_u}%}
			delete {punishtype::%{_u}%}
			delete {offensetype::%{_u}%}
			add 1 to {log::offenses::%{_offensetype}%%{_punishtype}%::%{_pu}%}
			add {_id} to {log::mypunishments::ids::%{_pu}%::*}
			add {_id} to {log::mymoderations::ids::%{_u}%::*}
			set {log::punish::punishtype::%{_id}%} to {_punishtype} in strict proper case
			set {log::punish::mod::%{_id}%} to {_mod}
			set {log::punish::punished::%{_id}%} to {_punished}
			set {log::punish::reason::%{_id}%} to name of slot clicked raw slot of event-inventory
			set {log::punish::offensetype::%{_id}%} to {_offensetype} in strict proper case
			set {log::punish::offensenum::%{_id}%} to {log::offenses::%{_offensetype}%%{_punishtype}%::%{_pu}%}
			set {log::punish::date::%{_id}%} to now
			set {log::punish::length::%{_id}%} to returnTimeSpan({_punished}, {_offensetype}, {_punishtype})
			if {_punishtype} is "mute":
				mute({_punished}, {_mod}, "%returnTimeSpan({_punished}, {_offensetype}, {_punishtype})%" parsed as a timespan, name of slot clicked raw slot of event-inventory)
				send "%nl%{@punishprefix} &c%{_punished}% &7has been &cmuted &7for &c%returnTimeSpan({_punished}, {_offensetype}, {_punishtype})% &7for &c%{log::punish::reason::%{_id}%}%&7!%nl%" to all players
				set {_time} to returnTimeSpan({_punished}, {_offensetype}, {_punishtype})
				punishEmbed({_mod}, {_punished}, "Mute", {log::punish::reason::%{_id}%}, {_time}, {_id}, black)
			else if {_punishtype} is "ban":
				ban({_punished}, {_mod}, "%returnTimeSpan({_punished}, {_offensetype}, {_punishtype})%" parsed as a timespan, name of slot clicked raw slot of event-inventory)
				send "%nl%{@punishprefix} &c%{_punished}% &7has been &cbanned &7for &c%returnTimeSpan({_punished}, {_offensetype}, {_punishtype})% &7for &c%{log::punish::reason::%{_id}%}%&7!%nl%" to all players
				set {_time} to returnTimeSpan({_punished}, {_offensetype}, {_punishtype})
				punishEmbed({_mod}, {_punished}, "Ban", {log::punish::reason::%{_id}%}, {_time}, {_id}, red)
			play sound "block.note_block.pling" at pitch 0 to all players
			close event-player's inventory

function returnTimeSpan(player: offline player, offensetype: text, punishtype: text) :: text:
	set {_u} to uuid of {_player}
	set {_offensenum} to {log::offenses::%{_offensetype}%%{_punishtype}%::%{_u}%}
	if "%{_offensetype}%%{_punishtype}%" is "mediummute" or "lightban":
		if {_offensenum} is greater than 4:
			set {_offensenum} to 4
	else if "%{_offensetype}%%{_punishtype}%" is "highmute" or "mediumban" or "highban":
		if {_offensenum} is greater than 3:
			set {_offensenum} to 3
	else:
		if {_offensenum} is greater than 5:
			set {_offensenum} to 5
	if {%{_offensetype}%%{_punishtype}%::%{_offensenum}%} = "PERM":
		return "&ceternity"
	else:
		return "%{%{_offensetype}%%{_punishtype}%::%{_offensenum}%}%"

function punishEmbed(mod: player, punished: offlineplayer, type: text, reason: text, time: text, id: text, color: object):
	set {_u} to uuid of {_mod}
	set {_u2} to uuid of {_punished}
	make embed:
		set title of embed to "%{_type}% for **%{_punished}%**"
		set description of embed to "Punish ID: %{_id}%"
		set footer of embed to a footer with text "Issued by: %{_mod}%" and icon "https://minotar.net/avatar/%{_u}%"
		set thumbnail of embed to "https://minotar.net/avatar/%{_u2}%"
		add field named "Player:" with value "%{_punished}%" to embed
		add field named "Reason:" with value "%{_reason}%" to embed
		add field named "Length:" with value {_time} to embed
		set timestamp of embed to now
	send last made embed to channel with id "{@punishLog}" with "{@botName}"