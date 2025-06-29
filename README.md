# orchestrating_workflows_genai_applications

## Objectif du projet

Ce projet a pour objectif de démontrer comment orchestrer des workflows pour des applications utilisant l’Intelligence Artificielle Générative (GenAI) à l’aide d’Apache Airflow. Il propose des exemples de DAGs, des scripts d’aide, ainsi qu’une configuration prête à l’emploi pour déployer et gérer vos pipelines de données et d’IA.

## Prérequis

Avant de commencer, assurez-vous d’avoir les éléments suivants installés sur votre machine :

- Python 3.8 ou supérieur
- [Docker](https://www.docker.com/) (pour l’exécution locale ou le déploiement)
- [Astro CLI](https://www.astronomer.io/docs/astro/cli/develop-project) (pour le développement et le déploiement sur Astronomer)
- Un compte GitHub (pour l’intégration continue et le déploiement)
- (Optionnel) Un compte Astronomer pour le déploiement cloud

## Ressources utiles

- [Développer votre projet Astro](https://www.astronomer.io/docs/astro/cli/develop-project)
- [Projet de démarrage Astro (exemples de DAGs)](https://github.com/astronomer/astro-example-dags)
- [Déployer le code avec l’intégration GitHub d’Astro](https://www.astronomer.io/docs/astro/deploy-github-integration)
- [Introduction sur Apache Airflow](https://blog.stephane-robert.info/docs/services/scheduling/apache-airflow/)

## Structure du projet

- `dags/` : Contient les DAGs Airflow d’exemple pour orchestrer des workflows GenAI.
- `helper.py` : Fonctions utilitaires pour les DAGs.
- `include/` : Données et ressources additionnelles utilisées par les workflows.
- `tests/` : Tests pour valider l’intégrité des DAGs.
- `workflows/` : Fichiers de configuration pour l’intégration et le déploiement CI/CD.
- `Dockerfile` : Pour l’exécution locale ou le déploiement dans un conteneur Docker.
- `requirements.txt` : Dépendances Python nécessaires au projet.
- `packages.txt` : Liste de paquets système à installer lors du build sur Astronomer.

## Lancement rapide

1. Clonez ce dépôt.
2. Installez les dépendances :  
   `pip install -r requirements.txt`
3. (Optionnel) Lancez le projet avec Docker ou Astro CLI selon votre environnement.

## Déploiement sur Astro avec l’intégration GitHub

> **Important :**  
> Si vous utilisez l’intégration native GitHub d’Astronomer, il n’est pas nécessaire d’avoir un dossier `workflows/` ou de configurer des GitHub Actions pour le déploiement CI/CD.  
> L’intégration native permet de connecter directement votre dépôt à Astro et déclenche automatiquement les déploiements lors des commits ou des pull requests fusionnées sur les branches mappées.  
> Utilisez un dossier `workflows/` uniquement si vous souhaitez des automatisations personnalisées (tests, lint, etc.) en plus du déploiement.

Pour plus d’informations, consultez la documentation officielle :  
https://www.astronomer.io/docs/astro/deploy-github-integration/

## CI/CD manuel avec GitHub Actions

Si tu souhaites configurer un pipeline CI/CD personnalisé pour déployer tes DAGs sur Astro à l’aide de GitHub Actions (et donc d’un dossier `workflows`), suis le guide officiel :

👉 [Mettre en place le CI/CD avec GitHub Actions sur Astronomer](https://www.astronomer.io/docs/astro/first-dag-github-actions/)

Ce tutoriel explique étape par étape :
- Comment créer un déploiement Astro
- Comment forker un projet exemple
- Comment configurer le workflow GitHub Actions pour déployer automatiquement sur Astro
- Comment déclencher et vérifier le déploiement

> **Remarque :**  
> Cette méthode est utile si tu veux garder le contrôle sur tes workflows CI/CD ou si tu ne souhaites pas utiliser l’intégration native GitHub d’Astronomer.

Pour plus d’informations, consulte la documentation officielle d’Astronomer.

## Configuration de Weaviate Cloud

Ce projet peut utiliser [Weaviate Cloud](https://weaviate.io/developers/weaviate/cloud) comme base de données vectorielle pour stocker et rechercher des embeddings.

### 1. Création d’un compte et d’une instance Weaviate Cloud

1. Rendez-vous sur [Weaviate Cloud Console](https://console.weaviate.cloud/).
2. Créez un compte ou connectez-vous.
3. Créez une nouvelle instance (choisissez la région, le nom, etc.).
4. Une fois l’instance créée, récupérez :
   - L’**URL de l’instance** (ex : `https://my-instance.weaviate.network`)
   - Le **API Key** ou le **token d’authentification** si activé

### 2. Configuration de la connexion dans Airflow

Pour que vos DAGs Airflow puissent accéder à Weaviate, il faut configurer une connexion dans l’interface Airflow :

1. Ouvrez l’interface web d’Airflow.
2. Allez dans le menu **Admin > Connections**.
3. Cliquez sur **+** pour ajouter une nouvelle connexion.
4. Remplissez les champs comme suit :
   - **Conn Id** : `my_weaviate_conn`  
     > C’est ce nom qui sera utilisé dans le code pour référencer la connexion.
   - **Conn Type** : `HTTP` (ou personnalisé si un provider Weaviate est installé)
   - **Host** : l’URL de votre instance Weaviate (ex : `https://my-instance.weaviate.network`)
   - **Password** ou **Extra** : ajoutez ici le token d’authentification/API Key si nécessaire, par exemple :
     ```json
     {"X-OpenAI-Api-Key": "votre-cle-api"}
     ```
   - **Description** : (optionnel) Connexion à Weaviate Cloud

5. Enregistrez la connexion.

### 3. Utilisation de `my_weaviate_conn` dans le code

Dans vos DAGs ou scripts, vous pouvez référencer cette connexion par son `Conn Id` :

```python
from airflow.hooks.base import BaseHook

conn = BaseHook.get_connection("my_weaviate_conn")
weaviate_url = conn.host
api_key = conn.password  # ou via conn.extra si stocké dans Extra
```

> **Remarque :**  
> Le nom `"my_weaviate_conn"` est arbitraire, mais il doit correspondre exactement au `Conn Id` défini dans Airflow.  
> Modifiez-le dans le code si vous choisissez un autre nom lors de la configuration.

Pour plus d’informations, consulte la [documentation officielle Weaviate Cloud](https://weaviate.io/developers/weaviate/cloud) et la [documentation Airflow sur les connexions](https://airflow.apache.org/docs/apache-airflow/stable/howto/connection/index.html).

---

N’hésitez pas à consulter les ressources ci-dessus pour approfondir vos connaissances sur Airflow et Astronomer. 

> **Important :**  
> Le fichier `packages.txt` doit être présent à la racine du projet pour que le build sur Astronomer fonctionne, même s’il est vide.  
> Ce fichier permet d’installer des paquets système supplémentaires lors du build.  
> Si tu n’as pas de dépendances système à ajouter, laisse-le vide. 