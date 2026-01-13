# CI/CD Setup 

### **(GitHub Actions → GCP Cloud Run \+ Artifact Registry)**

This repo uses **GitHub OIDC (Workload Identity Federation)** to authenticate to Google Cloud **without storing any JSON keys**.

## **0\) Prerequisites**

* A Google Cloud project with billing enabled

* gcloud CLI installed locally

* GitHub repository admin access (to add secrets)

Set project:

```
gcloud config set project <PROJECT_ID>
```

## **1\) Enable required APIs**

```
gcloud services enable \
  run.googleapis.com \ 
  artifactregistry.googleapis.com \
  iamcredentials.googleapis.com \ 
  sts.googleapis.com
```

## **2\) Create Artifact Registry repository**

```
gcloud artifacts repositories create <AR_REPO> \
  --repository-format=docker \
  --location=<REGION>
```

Example:

* ```REGION=europe-southwest1```

* ```AR_REPO=devops-playground```

## **3\) Create a Service Account for GitHub Actions**

```
gcloud iam service-accounts create gha-deployer \
  --display-name="GitHub Actions Deployer"
```

Set variable:

```
SA_EMAIL="gha-deployer@<PROJECT_ID>.iam.gserviceaccount.com"
```

## **4\) Grant IAM permissions to the Service Account**

Minimum for:

* push images to Artifact Registry

* deploy Cloud Run services

```
gcloud projects add-iam-policy-binding <PROJECT_ID\> \ 
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/run.admin"

gcloud projects add-iam-policy-binding <PROJECT_ID> \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/artifactregistry.writer"

gcloud projects add-iam-policy-binding <PROJECT_ID> \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/iam.serviceAccountUser"
```

## **5\) Create Workload Identity Pool \+ Provider (GitHub OIDC)**

### **5.1 Create pool**

```
POOL_ID="github-pool"  
gcloud iam workload-identity-pools create "$POOL_ID" \  
  --location="global" \
  --display-name="GitHub Actions Pool"
```


### **5.2 Create provider (restrict to your GitHub repo)**

Set:

* ```PROVIDER_ID="github-provider"```

* ```GITHUB_REPO="<OWNER>/<REPO>"``` (example: ```elmika/ephemeral-setup```)

* ```PROJECT_NUMBER```:
```PROJECT_NUMBER="$(gcloud projects describe <PROJECT_ID> --format='value(projectNumber)')"
```

Create provider:

```
PROVIDER_ID="github-provider"  
GITHUB_REPO="<OWNER>/<REPO>"

gcloud iam workload-identity-pools providers create-oidc "$PROVIDER_ID" \
  --location="global" \
  --workload-identity-pool="$POOL_ID" \
  --display-name="GitHub OIDC Provider" \
  --issuer-uri="https:/token.actions.githubusercontent.com" \
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository,attribute.ref=assertion.ref" \  
  --attribute-condition="assertion.repository == '${GITHUB_REPO}'"
```


### **5.3 Allow the GitHub repo to impersonate the Service Account**

Compute provider resource name:

```
WIF_PROVIDER="projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL_ID}/providers/${PROVIDER_ID}"
```

Bind workloadIdentityUser:

```
gcloud iam service-accounts add-iam-policy-binding "$SA_EMAIL" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL_ID}/attribute.repository/${GITHUB_REPO}"
```

Bind serviceAccountTokenCreator (required to mint access tokens):

```
gcloud iam service-accounts add-iam-policy-binding "$SA_EMAIL" \
  --role="roles/iam.serviceAccountTokenCreator" \
  --member="principalSet://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL_ID}/attribute.repository/${GITHUB_REPO}"
```

## **6\) Add GitHub Secret**

In GitHub repo → Settings → Secrets and variables → Actions → New repository secret:

* ```GCP_WIF_PROVIDER = value of $WIF_PROVIDER```, e.g.

```projects/\<PROJECT_NUMBER\>/locations/global/workloadIdentityPools/github-pool/providers/github-provider```

## **7\) Configure workflows variables**

In ```.github/workflows/*.yml```, set:

* ```PROJECT_ID```

* ```REGION```

* ```REPO``` (Artifact Registry repo name)

* ```IMAGE_NAME / SERVICE_BASE```

## **8\) Run the workflows**

From GitHub → Actions:

* **Build & Push (Artifact Registry)** (manual: workflow_dispatch)

* **Deploy Ephemeral (Cloud Run)** (manual, takes env_name and image_tag)

---

## **Troubleshooting**

### **iamcredentials.googleapis.com is disabled**

Enable API:

```gcloud services enable iamcredentials.googleapis.com```

### **iam.serviceAccounts.getAccessToken denied**

Ensure the repo principal has:

* ```roles/iam.workloadIdentityUser```

* ```roles/iam.serviceAccountTokenCreator```

   on the Service Account.

### **Docker push unauthenticated**

Ensure workflow runs:

```gcloud auth configure-docker <REGION>-docker.pkg.dev --quiet```

---

## **Opinionated notes**

* Use :latest for ephemeral environments only.

* Prefer deploying :```<GITHUB_SHA>``` to ensure determinism.