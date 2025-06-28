# DevOps Pets - Auto-Deployment Guide

## 🚀 Πλήρης Αυτοματοποίηση Deployment

Το project τώρα υποστηρίζει πλήρη αυτοματοποίηση με υποστήριξη για υπάρχοντα projects και ενημερώσεις.

## 📋 Επιλογές Deployment

### 1. **Πλήρως Αυτοματοποιημένο (Συνιστάται)**

```bash
# Εκτέλεση απευθείας από GitHub
curl -sSL https://raw.githubusercontent.com/Tsilispyr/Devpets/main/auto-deploy.sh | bash
```

**Τι κάνει:**
- ✅ Ελέγχει system requirements
- ✅ Εγκαθιστά dependencies (git, curl, wget, unzip, ansible)
- ✅ Αν υπάρχει ήδη project: κάνει `git pull` για ενημερώσεις
- ✅ Αν δεν υπάρχει: κάνει `git clone`
- ✅ Αν υπάρχει ZIP file: το χρησιμοποιεί ως fallback
- ✅ Επιβεβαιώνει project structure
- ✅ Τρέχει Ansible deployment
- ✅ Εμφανίζει access URLs

### 2. **Από ZIP Download**

```bash
# 1. Κατεβάστε το ZIP από GitHub
# 2. Εκτελέστε το script
curl -sSL https://raw.githubusercontent.com/Tsilispyr/Devpets/main/deploy-from-zip.sh | bash
```

### 3. **Κλασικό Deployment**

```bash
# Clone και deploy
curl -sSL https://raw.githubusercontent.com/Tsilispyr/Devpets/main/deploy.sh | bash
```

## 🔄 Ενημερώσεις Project

### Αυτόματη Ενημέρωση

```bash
# Εκτελέστε ξανά το auto-deploy script
curl -sSL https://raw.githubusercontent.com/Tsilispyr/Devpets/main/auto-deploy.sh | bash
```

**Τι συμβαίνει:**
- 🔍 Εντοπίζει υπάρχον project
- 🔄 Κάνει `git pull` για νέες αλλαγές
- 🗑️ Διαγράφει παλιά containers/images
- 🏗️ Χτίζει νέα Docker images
- 🚀 Deploy-άρει ξανά με Ansible

### Χειροκίνητη Ενημέρωση

```bash
cd Devpets
git pull origin main
ansible-playbook -i ansible/inventory.ini ansible/deploy-all.yml
```

## 📁 Διαχείριση Υπάρχοντος Project

### Αν υπάρχει ήδη το project:

**Non-Interactive Mode (curl):**
- 🔄 Αυτόματα κάνει `git pull` για ενημερώσεις
- ✅ Χρησιμοποιεί υπάρχοντα project αν είναι git repository
- 🔧 Μετατρέπει σε git repository αν δεν είναι
- 🗑️ Διαγράφει αν είναι corrupted

**Interactive Mode:**
```
Options:
1. Update existing directory with latest changes (git pull)
2. Remove existing directory and clone fresh  
3. Use existing directory as-is
```

### Αν δεν υπάρχει project:

**Προτεραιότητα:**
1. 🐙 `git clone` από GitHub
2. 📦 Extract από `Devpets-main.zip` (αν υπάρχει)
3. 🔄 Retry με διαφορετικές προσπάθειες

## 🛠️ Scripts που Διατίθενται

| Script | Χρήση | Ειδικά Χαρακτηριστικά |
|--------|-------|----------------------|
| `auto-deploy.sh` | **Πλήρης αυτοματοποίηση** | Git pull, ZIP fallback, non-interactive |
| `deploy.sh` | Κλασικό deployment | Interactive options, git clone |
| `deploy-from-zip.sh` | ZIP-based deployment | ZIP extraction, git conversion |

## 🔧 Αντιμετώπιση Προβλημάτων

### Git Pull Fails
```bash
# Χειροκίνητη ενημέρωση
cd Devpets
git fetch origin
git reset --hard origin/main
```

### Corrupted Project
```bash
# Καθαρισμός και νέο clone
rm -rf Devpets
curl -sSL https://raw.githubusercontent.com/Tsilispyr/Devpets/main/auto-deploy.sh | bash
```

### Disk Space Issues
```bash
# Καθαρισμός Docker
docker system prune -a
docker volume prune
```

## 🌐 Access URLs μετά το Deployment

- **Frontend:** http://localhost:8081
- **Backend API:** http://localhost:8080  
- **Jenkins:** http://localhost:8082
- **Mailhog:** http://localhost:8025

## 📋 Χρήσιμες Εντολές

```bash
# Έλεγχος pods
kubectl get pods -n devops-pets

# Έλεγχος services  
kubectl get services -n devops-pets

# View logs
kubectl logs <pod-name> -n devops-pets

# Stop application
kubectl delete namespace devops-pets
```

## 🎯 Πλεονεκτήματα της Νέας Λειτουργικότητας

### ✅ Πλήρης Αυτοματοποίηση
- Μία εντολή για όλα
- Χειρίζεται όλα τα σενάρια
- Non-interactive mode

### ✅ Έξυπνη Διαχείριση Projects
- Git pull για ενημερώσεις
- ZIP fallback support
- Auto-conversion σε git repository

### ✅ Αξιοπιστία
- Retry mechanisms
- Error handling
- System requirements check

### ✅ Ευελιξία
- Interactive και non-interactive modes
- Πολλαπλές επιλογές deployment
- Fallback strategies

## 🚀 Γρήγορη Εκκίνηση

**Για νέο σύστημα:**
```bash
curl -sSL https://raw.githubusercontent.com/Tsilispyr/Devpets/main/auto-deploy.sh | bash
```

**Για ενημέρωση:**
```bash
curl -sSL https://raw.githubusercontent.com/Tsilispyr/Devpets/main/auto-deploy.sh | bash
```

**Αποτέλεσμα:** Πλήρως λειτουργικό DevOps Pets application σε λίγα λεπτά! 🎉 