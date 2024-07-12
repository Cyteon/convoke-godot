extends Node
class_name ConvokeClient

var host: String
var port: String
var secure: bool
var full_host: String
var http_request: HTTPRequest

var token: String

func _init(host: String, port: String, secure: bool) -> void:
	self.host = host
	self.port = port
	self.secure = secure
	self.full_host = ("https://" if secure else "http://") + host + ":" + port

func _ready() -> void:
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_ping_host_completed)
	
	# Now that we're in _ready(), we can safely call ping_host
	ping_host()

func ping_host() -> void:
	var error = http_request.request(full_host + "/api/ping")

func _ping_host_completed(result, response_code, headers, body):
	print(response_code, " | ", result, " | ", body)
	
	match result:
		HTTPClient.STATUS_CANT_CONNECT:
			print("Cant connect to host")
		HTTPClient.STATUS_CANT_RESOLVE:
			print("Cant resolve host")
		_:
			print("Pinging host returned code: " + str(response_code))
	# Handle the response as needed

func _new_player_completed(result, response_code, headers, body) -> void:
	print(response_code, JSON.parse_string(body.get_string_from_utf8()))

func new_player(username: String, email: String, password: String) -> void:
	print("Creating player: " + username)
	
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_new_player_completed)
	
	http_request.request(full_host + "/api/player/new", ["Content-Type: application/json"], HTTPClient.METHOD_POST, JSON.stringify({
		"email": email,
		"username": username,
		"password": password
	}))

func _login_player_completed(result, response_code, headers, body) -> void:
	print(response_code, JSON.parse_string(body.get_string_from_utf8()))
	
	if response_code == 200:
		token = JSON.parse_string(body.get_string_from_utf8())["token"]
	
func login_player(password: String, username: String = "", email: String = "") -> void:
	print("Logging in")
	
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_login_player_completed)
	
	http_request.request(full_host + "/api/player/login", ["Content-Type: application/json"], HTTPClient.METHOD_POST, JSON.stringify({
		"email": email,
		"username": username,
		"password": password
	}))
