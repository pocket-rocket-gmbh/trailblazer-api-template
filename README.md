# README

## Get Routes

`bundle exec rake grape:routes`

## Edit Secrets

`EDITOR=nano rails credentials:edit`

## Authentication

# Local environment

```
export BASE_URL="localhost:3000"

curl -X POST -d '{"email": "info@pocket-rocket.io", "password": "Testpass1234!"}' $BASE_URL/v1/auth -v -H Content-Type:application/json |jq '.'

export JWT_TOKEN="replace_from_auth_result"
```

## Concepts

### Organizations
```
# Retrieve a list of organizations
curl "$BASE_URL/v1/organizations" -v -H Content-Type:application/json -H "Authorization: Bearer $JWT_TOKEN" |jq '.'

# Retrieve a single organization
curl "$BASE_URL/v1/organizations/1" -v -H Content-Type:application/json -H "Authorization: Bearer $JWT_TOKEN" |jq '.'
```
