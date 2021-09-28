# README

## Get Endpoint Routes

`bundle exec rake grape:routes`

## Edit Secrets

Please note that this App uses Rails 6 based credentials. You may have to setup a new master.key to make it work.

`EDITOR=nano rails credentials:edit`

## Authentication

### Local environment

```
export BASE_URL="localhost:3000"

curl -X POST -d '{"email": "info@pocket-rocket.io", "password": "PassWord9876"}' $BASE_URL/v1/auth -v -H Content-Type:application/json |jq '.'

export JWT_TOKEN="replace_from_auth_result"
```

## Request examples

### Organizations
```
# ------ CRUD ------

# Create an organization
curl -d '{"name": "Super Corp","website":"www.super-corp.com"}' "$BASE_URL/v1/organizations" -v -H Content-Type:application/json -H "Authorization: Bearer $JWT_TOKEN" |jq '.'

# Update an organization
curl -X PUT -d '{"name": "New Org Name"}' "$BASE_URL/v1/organizations/1" -v -H Content-Type:application/json -H "Authorization: Bearer $JWT_TOKEN" |jq '.'

# Retrieve a single organization
curl "$BASE_URL/v1/organizations/1" -v -H Content-Type:application/json -H "Authorization: Bearer $JWT_TOKEN" |jq '.'

# Delete an organization
curl -X DELETE "$BASE_URL/v1/organizations/1" -v -H Content-Type:application/json -H "Authorization: Bearer $JWT_TOKEN" |jq '.'

# ------ Other ------

# Retrieve a list of organizations
curl "$BASE_URL/v1/organizations" -v -H Content-Type:application/json -H "Authorization: Bearer $JWT_TOKEN" |jq '.'
```
