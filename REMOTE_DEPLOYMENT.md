# Remote Deployment Guide

## Εγκατάσταση σε άλλο σύστημα με curl

### Προαπαιτούμενα

Πριν τρέξεις το deployment, βεβαιώσου ότι έχεις εγκαταστήσει:

- **Docker**: `https://docs.docker.com/get-docker/`
- **kind**: `https://kind.sigs.k8s.io/docs/user/quick-start/#installation`
- **kubectl**: `https://kubernetes.io/docs/tasks/tools/install-kubectl/`
- **Ansible**: `https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html`
- **curl**: Συνήθως είναι ήδη εγκατεστημένο
- **unzip**: Συνήθως είναι ήδη εγκατεστημένο

### Επιλογή 1: Απλό curl deployment (Συνιστάται)

```bash
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/pets-devops/main/auto-deploy-remote.sh | bash
```

**Σημείωση**: Αντικατέστησε `YOUR_USERNAME` με το πραγματικό GitHub username σου.

### Επιλογή 2: Λεπτομερές deployment με έλεγχο

```bash
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/pets-devops/main/curl-deploy.sh | bash
```

### Επιλογή 3: Manual download και deployment

```bash
# Download και extract
curl -L -o pets-devops.zip https://github.com/YOUR_USERNAME/pets-devops/archive/refs/heads/main.zip
unzip pets-devops.zip
cd pets-devops-main

# Deploy infrastructure
ansible-playbook -i localhost, -c local ansible/deploy-all.yml

# Deploy applications (αν υπάρχουν)
ansible-playbook -i localhost, -c local ansible/deploy-applications.yml
```

## Τι κάνει το script

1. **Ελέγχει τα απαραίτητα εργαλεία** (Docker, kind, kubectl, Ansible)
2. **Κατεβάζει το project** από το GitHub
3. **Εξάγει τα αρχεία** στο `/tmp/pets-devops-auto-deploy`
4. **Δημιουργεί νέο cluster** με kind
5. **Δημιουργεί namespace** `pets-devops`
6. **Κατασκευάζει Docker images** για Jenkins, MailHog, PostgreSQL
7. **Φορτώνει τα images** στο cluster
8. **Εφαρμόζει τα Kubernetes manifests**
9. **Περιμένει τα pods να είναι ready**
10. **Ρυθμίζει port forwarding**
11. **Επιλογικά deployάρει applications** (frontend/backend)

## URLs μετά το deployment

- **Jenkins**: http://localhost:8080
- **MailHog**: http://localhost:8025
- **PostgreSQL**: localhost:5432
- **Frontend** (αν deployαρθεί): http://localhost:3000
- **Backend** (αν deployαρθεί): http://localhost:8081

## Χρήσιμες εντολές

```bash
# Δες τα pods
kubectl get pods -n pets-devops

# Δες τα logs
kubectl logs -n pets-devops <pod-name>

# Δες λεπτομέρειες pod
kubectl describe pod -n pets-devops <pod-name>

# Δες όλους τους πόρους
kubectl get all -n pets-devops

# Σταμάτησε port forwarding
pkill -f "kubectl port-forward"

# Διαγραφή όλου του deployment
kubectl delete namespace pets-devops --force
kind delete cluster --name devops-pets
```

## Troubleshooting

### Αν το deployment αποτύχει:

1. **Ελέγξε τα logs**:
   ```bash
   kubectl logs -n pets-devops <pod-name>
   ```

2. **Ελέγξε την κατάσταση των pods**:
   ```bash
   kubectl get pods -n pets-devops -o wide
   ```

3. **Ελέγξε τα events**:
   ```bash
   kubectl get events -n pets-devops --sort-by='.lastTimestamp'
   ```

4. **Κάνε cleanup και ξαναπροσπάθησε**:
   ```bash
   kubectl delete namespace pets-devops --force
   kind delete cluster --name devops-pets
   # Τρέξε ξανά το curl command
   ```

### Αν δεν έχεις τα απαραίτητα εργαλεία:

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install -y docker.io curl unzip
sudo systemctl start docker
sudo systemctl enable docker

# kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Ansible
sudo apt install -y ansible
```

**macOS:**
```bash
# Με Homebrew
brew install docker kind kubectl ansible

# Ξεκίνησε Docker Desktop
open /Applications/Docker.app
```

**Windows:**
```bash
# Εγκατάστησε Docker Desktop, kind, kubectl, Ansible
# Ακολούθησε τις επίσημες οδηγίες εγκατάστασης
```

## Cleanup

Για να καθαρίσεις τα προσωρινά αρχεία:

```bash
rm -rf /tmp/pets-devops-auto-deploy
```

Για να διαγράψεις όλο το deployment:

```bash
kubectl delete namespace pets-devops --force
kind delete cluster --name devops-pets
``` 