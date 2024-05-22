#set env vars
set -o allexport; source .env; set +o allexport;

# apt install jq -y

chmod +x ./scripts/*.sh
mkdir -p ./config/uc/fixtures
chown -R 1000:1000 ./config/uc/fixtures

if [ -e "./config/uc/fixtures/oidc-server-grist-client.json" ]; then
   exit 0;
fi

OIDC_CLIENT_SECRET=${MINIO_SECRET_KEY:-`openssl rand -hex 28`}
GRIST_SECRET_KEY=${GRIST_SECRET_KEY:-`openssl rand -hex 32`}


cat << EOT >> ./.env

OIDC_CLIENT_SECRET=${OIDC_CLIENT_SECRET}
DEBUG=0
LANGUAGE_CODE=en-us
TIME_ZONE=UTC
FORCE_SCRIPT_NAME=/uc
SECRET_KEY=${GRIST_SECRET_KEY}

EOT


cat << EOT >> ./config/uc/fixtures/oidc-server-grist-client.json

[
    {
     "model": "oidc_provider.client",
     "pk": 1,
     "fields": {
      "name": "outline",
      "owner": null,
      "client_type": "confidential",
      "client_id": "050984",
      "client_secret": "$OIDC_CLIENT_SECRET",
      "jwt_alg": "RS256",
      "date_created": "2022-02-15",
      "website_url": "",
      "terms_url": "",
      "contact_email": "",
      "logo": "",
      "reuse_consent": true,
      "require_consent": true,
      "_redirect_uris": "https://$DOMAIN/auth/oidc.callback",
      "_post_logout_redirect_uris": "",
      "_scope": "",
      "response_types": [
       1,
       2,
       3,
       4,
       5,
       6
      ]
     }
    }
    ]


EOT