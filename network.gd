extends Node

const DEFAULT_PORT = 28960
const MAX_CLIENTS = 3

var server = null
var client = null

var ip_address = "10.0.0.8"

func _ready():
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connection_failed", self, "_connection_failed")
	get_tree().connect("network_peer_connected", self, "_player_connected")

func create_server():
	print("Creating Server")
	get_tree().change_scene("res://FPS.tscn")
	server = NetworkedMultiplayerENet.new()
	server.create_server(DEFAULT_PORT, MAX_CLIENTS)
	get_tree().set_network_peer(server)

func join_server():
	print("Joining Server")
	get_tree().change_scene("res://FPS.tscn")
	client = NetworkedMultiplayerENet.new()
	client.create_client(ip_address, DEFAULT_PORT)
	get_tree().set_network_peer(client)
	
func _connected_to_server():
	print("Connected to server")

func _server_disconnected():
	print("Disconnected from server")
	
	reset_network_connection()

func _connection_failed():
	print("Connection failed")
	
	reset_network_connection()

func _player_connected(id):
	print("Player connected" + str(id))
	
func reset_network_connection():
	if get_tree().has_network_peer():
		get_tree().network_peer = null
