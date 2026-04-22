$base = "http://localhost:8000"

curl.exe -s -X POST "$base/reset"
curl.exe -s -X POST "$base/ues" -H "Content-Type: application/json" --data-raw '{"ue_id":31}'
curl.exe -s -X POST "$base/ues/31/bearers" -H "Content-Type: application/json" --data-raw '{"bearer_id":1}'
curl.exe -s -X POST "$base/ues/31/bearers/1/traffic" -H "Content-Type: application/json" --data-raw '{"protocol":"tcp","Mbps":1}'
curl.exe -s -X GET "$base/ues/31/bearers/1/traffic"
curl.exe -s -X GET "$base/ues/31/bearers/1/traffic"
curl.exe -s -X GET "$base/ues/31/bearers/1/traffic"