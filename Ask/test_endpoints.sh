#!/bin/bash

# Βάλε εδώ το access token σου (μέσα στα εισαγωγικά)
TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJDSEs1cnpwUUtjXzhiUUY4SEl6ZF9pME9DNjdHTzlyckpmNkhoajB1WVM4In0.eyJleHAiOjE3NTA4NzA5MTIsImlhdCI6MTc1MDg3MDYxMiwianRpIjoiNWE4YmE4YmEtZWUyNS00ZTQ2LTlmMjYtNWZkN2U1OTRiNjUxIiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgzL3JlYWxtcy9wZXRzeXN0ZW0iLCJzdWIiOiI2NWRkNTExZC1kZThkLTQ3NTMtYTdlNy0zMDlmNzliZWVhNzYiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJmcm9udGVuZC12dWUiLCJzZXNzaW9uX3N0YXRlIjoiZDJhZGRjYWEtZTMxMy00MzExLWI2ZWItYTc0OTFmZTllNjdkIiwiYWNyIjoiMSIsImFsbG93ZWQtb3JpZ2lucyI6WyJodHRwOi8vbG9jYWxob3N0OjgwODEiXSwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIkFETUlOIl19LCJzY29wZSI6ImVtYWlsIHByb2ZpbGUiLCJzaWQiOiJkMmFkZGNhYS1lMzEzLTQzMTEtYjZlYi1hNzQ5MWZlOWU2N2QiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwibmFtZSI6IkFkbWluIFVzZXIiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJhZG1pbiIsImdpdmVuX25hbWUiOiJBZG1pbiIsImZhbWlseV9uYW1lIjoiVXNlciIsImVtYWlsIjoiYWRtaW5AZXhhbXBsZS5jb20ifQ.qfLuNoHDoX2rgVYjiO0qdPcGKJvpzEvjsM4EFsCS7IvYQJVdHgP7R78G1Z3zaRzUCferzNscH_dcJM3B4PQiOhWB10-oK-XIw2fgMazlaiXNQm9re7MNdI3epbcbYJVujdA4_5FLFEE8y7tPmO9bkelnrGO4Cs1Byq50x6WrBleQIyTPOUUt7W1kFFWi-hB_2SRIuaTF3_GcphITMPx2kRie9X-B1ySphK4c07y_XMIrukB2SgQ0ihVsNRUT5qWJEivCmNm5ECLcUtFEo13_-v46tPk_CXZjInlj2KKzEwzccTyAHJZ1Pymd7NskjdVCbPwhBm0UPttd9Z8kkNZdMw"

# UserController

echo "GET /users"
curl -i -s -H "Authorization: Bearer $TOKEN" http://localhost:8080/users
echo -e "\n-----------------------------\n"

echo "GET /user/1"
curl -i -s -H "Authorization: Bearer $TOKEN" http://localhost:8080/user/1
echo -e "\n-----------------------------\n"

echo "POST /user/1"
curl -i -s -X POST -H "Authorization: Bearer $TOKEN" http://localhost:8080/user/1
echo -e "\n-----------------------------\n"

echo "GET /user/role/delete/1/2"
curl -i -s -H "Authorization: Bearer $TOKEN" http://localhost:8080/user/role/delete/1/2
echo -e "\n-----------------------------\n"

echo "GET /user/role/add/1/2"
curl -i -s -H "Authorization: Bearer $TOKEN" http://localhost:8080/user/role/add/1/2
echo -e "\n-----------------------------\n"

# AnimalController

echo "GET /Animal/1"
curl -i -s -H "Authorization: Bearer $TOKEN" http://localhost:8080/Animal/1
echo -e "\n-----------------------------\n"

echo "POST /Animal"
curl -i -s -X POST -H "Authorization: Bearer $TOKEN" http://localhost:8080/Animal
echo -e "\n-----------------------------\n"

echo "PUT /Animal/1"
curl -i -s -X PUT -H "Authorization: Bearer $TOKEN" http://localhost:8080/Animal/1
echo -e "\n-----------------------------\n"

echo "DELETE /Animal/1"
curl -i -s -X DELETE -H "Authorization: Bearer $TOKEN" http://localhost:8080/Animal/1
echo -e "\n-----------------------------\n"

echo "PUT /Animal/Request/1"
curl -i -s -X PUT -H "Authorization: Bearer $TOKEN" http://localhost:8080/Animal/Request/1
echo -e "\n-----------------------------\n"

# RequestController

echo "GET /Request/1"
curl -i -s -H "Authorization: Bearer $TOKEN" http://localhost:8080/Request/1
echo -e "\n-----------------------------\n"

echo "PUT /Request/1"
curl -i -s -X PUT -H "Authorization: Bearer $TOKEN" http://localhost:8080/Request/1
echo -e "\n-----------------------------\n"

echo "DELETE /Request/1"
curl -i -s -X DELETE -H "Authorization: Bearer $TOKEN" http://localhost:8080/Request/1
echo -e "\n-----------------------------\n"

echo "GET /Request/Approve/1"
curl -i -s -H "Authorization: Bearer $TOKEN" http://localhost:8080/Request/Approve/1
echo -e "\n-----------------------------\n"

echo "PUT /Request/Approve/1"
curl -i -s -X PUT -H "Authorization: Bearer $TOKEN" http://localhost:8080/Request/Approve/1
echo -e "\n-----------------------------\n"

echo "GET /Request/ApproveD/1"
curl -i -s -H "Authorization: Bearer $TOKEN" http://localhost:8080/Request/ApproveD/1
echo -e "\n-----------------------------\n"

echo "GET /Request/new"
curl -i -s -H "Authorization: Bearer $TOKEN" http://localhost:8080/Request/new
echo -e "\n-----------------------------\n"

echo "POST /Request/new"
curl -i -s -X POST -H "Authorization: Bearer $TOKEN" http://localhost:8080/Request/new
echo -e "\n-----------------------------\n"

echo "POST /Request"
curl -i -s -X POST -H "Authorization: Bearer $TOKEN" http://localhost:8080/Request
echo -e "\n-----------------------------\n" 