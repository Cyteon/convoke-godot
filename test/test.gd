extends Control

var client : ConvokeClient

@onready var EmailEdit = $VBoxContainer/EmailEdit
@onready var UserNameEdit = $VBoxContainer/UserNameEdit
@onready var PasswordEdit = $VBoxContainer/PasswordEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	client = await ConvokeClient.new("0.0.0.0", "4200", false)
	add_child(client)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_login_button_pressed() -> void:
	client.login_player(PasswordEdit.text, UserNameEdit.text, EmailEdit.text)


func _on_create_acc_button_pressed() -> void:
	client.new_player(UserNameEdit.text, EmailEdit.text, PasswordEdit.text)
