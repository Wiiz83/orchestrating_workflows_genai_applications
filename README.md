# orchestrating_workflows_genai_applications

## Project Objective

This project aims to demonstrate how to orchestrate workflows for applications using Generative Artificial Intelligence (GenAI) with Apache Airflow. It provides example DAGs, helper scripts, and a ready-to-use configuration to deploy and manage your data and AI pipelines.

## Prerequisites

Before you start, make sure you have the following installed on your machine:

- Python 3.8 or higher
- [Docker](https://www.docker.com/) (for local execution or deployment)
- [Astro CLI](https://www.astronomer.io/docs/astro/cli/develop-project) (for development and deployment on Astronomer)
- A GitHub account (for continuous integration and deployment)
- (Optional) An Astronomer account for cloud deployment

## Useful Resources

- [Develop your Astro project](https://www.astronomer.io/docs/astro/cli/develop-project)
- [Astro starter project (example DAGs)](https://github.com/astronomer/astro-example-dags)
- [Deploy code with Astro's GitHub integration](https://www.astronomer.io/docs/astro/deploy-github-integration)
- [Introduction to Apache Airflow](https://blog.stephane-robert.info/docs/services/scheduling/apache-airflow/)

## Project Structure

- `dags/`: Contains example Airflow DAGs to orchestrate GenAI workflows.
- `helper.py`: Utility functions for the DAGs.
- `include/`: Additional data and resources used by the workflows.
- `tests/`: Tests to validate the integrity of the DAGs.
- `workflows/`: Configuration files for CI/CD integration and deployment.
- `Dockerfile`: For local execution or deployment in a Docker container.
- `requirements.txt`: Python dependencies required for the project.
- `packages.txt`: List of system packages to install during the build on Astronomer.

## Quick Start

1. Clone this repository.
2. Install the dependencies:  
   `pip install -r requirements.txt`
3. (Optional) Start the project with Docker or Astro CLI depending on your environment.

## Deployment on Astro with GitHub Integration

> **Important:**  
> If you use Astronomer's native GitHub integration, you do not need a `workflows/` folder or to configure GitHub Actions for CI/CD deployment.  
> The native integration allows you to connect your repository directly to Astro and automatically triggers deployments when commits or pull requests are merged into mapped branches.  
> Use a `workflows/` folder only if you want custom automations (tests, linting, etc.) in addition to deployment.

For more information, see the official documentation:  
https://www.astronomer.io/docs/astro/deploy-github-integration/

## Manual CI/CD with GitHub Actions

If you want to set up a custom CI/CD pipeline to deploy your DAGs to Astro using GitHub Actions (and thus a `workflows` folder), follow the official guide:

👉 [Set up CI/CD with GitHub Actions on Astronomer](https://www.astronomer.io/docs/astro/first-dag-github-actions/)

This tutorial explains step by step:
- How to create an Astro deployment
- How to fork an example project
- How to configure the GitHub Actions workflow to automatically deploy to Astro
- How to trigger and verify the deployment

> **Note:**  
> This method is useful if you want to keep control over your CI/CD workflows or if you do not want to use Astronomer's native GitHub integration.

For more information, see Astronomer's official documentation.

## Weaviate Cloud Configuration

This project can use [Weaviate Cloud](https://weaviate.io/developers/weaviate/cloud) as a vector database to store and search embeddings.

### 1. Create a Weaviate Cloud Account and Instance

1. Go to the [Weaviate Cloud Console](https://console.weaviate.cloud/).
2. Create an account or log in.
3. Create a new instance (choose region, name, etc.).
4. Once the instance is created, retrieve:
   - The **instance URL** (e.g., `https://my-instance.weaviate.network`)
   - The **API Key** or **authentication token** if enabled

### 2. Configure the Connection in Airflow

For your Airflow DAGs to access Weaviate, you need to configure a connection in the Airflow UI:

1. Open the Airflow web interface.
2. Go to **Admin > Connections**.
3. Click **+** to add a new connection.
4. Fill in the fields as follows:
   - **Conn Id**: `my_weaviate_conn`  
     > This is the name used in the code to reference the connection.
   - **Conn Type**: `HTTP` (or custom if a Weaviate provider is installed)
   - **Host**: the URL of your Weaviate instance (e.g., `https://my-instance.weaviate.network`)
   - **Password** or **Extra**: add the authentication token/API Key here if needed, for example:
     ```json
     {"X-OpenAI-Api-Key": "your-api-key"}
     ```
   - **Description**: (optional) Connection to Weaviate Cloud

5. Save the connection.

### 3. Using `my_weaviate_conn` in Code

In your DAGs or scripts, you can reference this connection by its `Conn Id`:

```python
from airflow.hooks.base import BaseHook

conn = BaseHook.get_connection("my_weaviate_conn")
weaviate_url = conn.host
api_key = conn.password  # or via conn.extra if stored in Extra
```

> **Note:**  
> The name `"my_weaviate_conn"` is arbitrary, but it must match exactly the `Conn Id` defined in Airflow.  
> Change it in the code if you choose another name during configuration.

For more information, see the [official Weaviate Cloud documentation](https://weaviate.io/developers/weaviate/cloud) and the [Airflow documentation on connections](https://airflow.apache.org/docs/apache-airflow/stable/howto/connection/index.html).

---

Feel free to consult the resources above to deepen your knowledge of Airflow and Astronomer.

> **Important:**  
> The `packages.txt` file must be present at the root of the project for the build on Astronomer to work, even if it is empty.  
> This file allows you to install additional system packages during the build.  
> If you have no system dependencies to add, leave it empty. 