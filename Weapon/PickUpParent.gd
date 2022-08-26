extends Area

onready var PickUpArea = $"."
var WeaponSwap: bool = false
var ParentGun

func _input(event):
	if event.is_action_pressed("ActionKey"):
		ParentGun = get_parent()
		
		var PlayerInteractionArea  = get_overlapping_areas()
		if PlayerInteractionArea.size() == 1 && WeaponSwap == true:
			print("Swap Weapon: ",PlayerInteractionArea[0].owner)
			PlayerInteractionArea[0].SwapWeaponInteraction(get_parent())
			get_parent().queue_free()


func _on_PickUpArea_body_entered(body):
	ParentGun = get_parent()
	
	if body.has_method("PickUpGun"):
		var HandOver = body.PickUpGun(ParentGun)
		#print(HandOver)
		if HandOver[0] == true: #Gun instantiated on the player: Delete Me!
			ParentGun.queue_free()
		elif HandOver[1] == ParentGun.UID: #Check And Hand over Ammo instead
			AmmoChangeOver(body)
				
		elif HandOver[1] != ParentGun.UID: #Check to see if the gun can be swapped
			WeaponSwap = true

func _on_Timer_timeout():
	PickUpArea.set_monitoring(true)
	
func _on_PickUpArea_area_entered(area):
	var player = area.owner
	_on_PickUpArea_body_entered(player)
	if player.has_method("ShowSwap") && WeaponSwap == true:
		player.ShowSwap(true)

func _on_PickUpArea_area_exited(area):
	var player = area.owner
	if player.has_method("ShowSwap"):
		player.ShowSwap(false)

func AmmoChangeOver(b):
	var AmmoType = ParentGun.UID
	var Amount = ParentGun.CurrentAmmo + ParentGun.CurrentCapacity
	var Taken = b.PickUpAmmo(AmmoType, Amount)
	
	if Amount == Amount-Taken:
		return

	if ParentGun.CurrentAmmo-Taken < 0:
		ParentGun.CurrentCapacity = ParentGun.CurrentCapacity-Taken
	else:
		ParentGun.CurrentAmmo = ParentGun.CurrentAmmo - Taken
		
	if ParentGun.CurrentCapacity < 0:
		ParentGun.CurrentAmmo = ParentGun.CurrentAmmo+ParentGun.CurrentCapacity
		ParentGun.CurrentCapacity = 0

	if ParentGun.CurrentAmmo < 0:
		ParentGun.CurrentAmmo = 0	
	
	if ParentGun.CurrentAmmo <= 0 && ParentGun.CurrentCapacity <= 0:
		ParentGun.queue_free()
	##This Horrible Code! Please Fix!!!

func RemoveWeapon():
	ParentGun = get_parent()
	ParentGun.queue_free()
