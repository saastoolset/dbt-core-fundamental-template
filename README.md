# `dbt-core` Fundamentals Tutorial

dbt-core Fundamentals template in PostgreSQL and podman

[![Generic badge](https://img.shields.io/badge/dbt-1.8.8-blue.svg)](https://docs.getdbt.com/dbt-cli/cli-overview)
[![Generic badge](https://img.shields.io/badge/PostgreSQL-16-blue.svg)](https://www.postgresql.org/)
[![Generic badge](https://img.shields.io/badge/Python-3.11.10-blue.svg)](https://www.python.org/)
[![Generic badge](https://img.shields.io/badge/Podman-5.0.2-blue.svg)](https://www.docker.com/)

  This `dbt-core` quickstart taken from the various [dbt Developer Hub](https://docs.getdbt.com/guides) and [dbt courses](https://courses.getdbt.com/collections), using `PostgreSQL` as the data warehouse. There you are going to find the following  course:

- [dbt Fundamentals](https://courses.getdbt.com/courses/fundamentals)
- [Jinja, Macros, Packages](https://courses.getdbt.com/courses/jinja-macros-packages)
- [Advanced Materializations](https://courses.getdbt.com/courses/advanced-materializations)
- [Analyses and Seeds](https://courses.getdbt.com/courses/analyses-seeds)
- [Refactoring SQL for Modularity](https://courses.getdbt.com/courses/refactoring-sql-for-modularity)

In this tutorial, for the purpose of `dbt-core` exercises, I made some modifications to the `profiles.yml` file to use the local `PostgreSQL` repository.

# Contents

## Preparation

### Create repository
1. Create a new GitHub repository

- Find our Github template repository [dbt-fundamental-template](https://github.com/saastoolset/dbt-fundamental-template)
- Click the big green 'Use this template' button and 'Create a new repository'.
- Create a new GitHub repository named **dbt-fund-ex1**.

![Click use template](.github/static/use-template.gif)

1. Select Public so the repository can be shared with others. You can always make it private later.
2. Leave the default values for all other settings.
3. Click Create repository.
4. Save the commands from "…or create a new repository on the command line" to use later in Commit your changes.
5. Install and setup envrionment


### Create venv
- Create python virtual env for dbt
  - For venv and and docker, using the [installation instructions](https://docs.getdbt.com/docs/core/installation-overview) for your operating system.
  - For conda in Windows, open conda prompt terminal in system administrador priviledge

    ```
    (base) C:> cd C:\Proj\CUB-EDW\50-GIT\dbt-fund-ex1\bin
    (base) C:> conda env create -n dbt -python 3.11.10
    (base) C:> conda activate dbt
    ```


- Install dbt Core
  ```command
        (dbt) C:> conda install dbt-core dbt-postgres
  ```

###  Start database
- Start up db and pgadmin
  . use admin/Password as connection

  ```
  (dbt) C:> cd C:\Proj\CUB-EDW\50-GIT\dbt-fund-ex1\bin
  (dbt) C:> db-start-pg.bat
  ``` 


### Project Set Up

- Init project in repository home directory
  Initiate the jaffle_shop project using the init command:

```
C:> cd C:\Proj\CUB-EDW\50-GIT\dbt-fund-ex1
C:> dbt init jaffle_shop
```

- Connect to PostgreSQL

- Update `profiles.yml`
Now we should create the `profiles.yml` file on the `C:\Users\YourID\.dbt` directory. The file should look like this:


```YAML
config:
    use_colors: True 
jaffle_shop:
  outputs:
    dev:
      type: postgres
      threads: 1
      host: localhost
      port: 5432
      user: "admin"
      pass: "Passw0rd"
      dbname: raw
      schema: dev
    prod:
      type: postgres
      threads: 1
      host: localhost
      port: 5432
      user: "admin"
      pass: "Passw0rd"
      dbname: raw
      schema: analytics
  target: dev
```

- Test connection config

```
C:> dbt debug
``` 


- Load sample data
 We should copy this data from the `db/seeds` directory.


  - Edit `dbt_project.yml`
  Now we should create the `dbt_project.yml` file on the `jaffle_shop` directory. Append following config:

  ```YAML
  seeds:
    jaffle_shop:
      +schema: jaffle_shop
  ```


  - copy seeds data
  ```
  C:> copy ..\db\seeds\*.csv seeds
  C:> dbt seed
  ```

- Verfiy result in database client
This command will spin and will create the `dbt_jaffle_shop` schema, and create and insert the `.csv` files to the following tables:

  - `dbt_jaffle_shop.customers`
  - `dbt_jaffle_shop.orders`
  - `dbt_jaffle_shop.payments`

### dbt command overview

To run `dbt`, we just execute, inside `jaffle_shop` directory

```
dbt run --profiles-dir .
```

This will run all the modles defined on the `models` directory.

In case you only want to run 1 model, you can execute

```
dbt run -m FILE_NAME --profiles-dir .
```

In case you only want to run 1 model and all the other ones that depends on it, you can execute

```
dbt run -m FILE_NAME+ --profiles-dir .
```

In case you only want to run 1 model and all the previous ones, you can execute

```
dbt run -m +FILE_NAME --profiles-dir .
```

In case you only want to run 1 model, all the previous ones and all the dependencies, you can execute

```
dbt run -m +FILE_NAME+ --profiles-dir .
```

To compile the queries, we can run:

```
dbt compile --profiles--dir .
```

That command will save the compiled queries on `target/compiled/PROJECT_NAME/models` directory

## Models

### Naming Conventions

- source: raw tables that are stored form differnet processes on the warehouse.
- staging: 1to1 with source table, where some minimal transformations can be done.
- intermediate: models between staging and final models (always built on staging)
  - fact tables: things that are ocurring or have ocurred (events)
  - dimension tables: things that "are" or "exists" (people, places, etc)

### Project Reorganization

- create folders inside `models` directory:
  - staging: will store all th staging models
    - one folder per schema, onde file per table
  - mart: will store the final outputs aht are modeled.
    - a best practice is to create a folder inside mart, per area (marketing, finance, etc)
- use the `ref` function to reference to another model (a staging table or a dim table or a fcat table)

Changes en `dbt_project.yml`:

- here you can choose the materialization of each dataproduct (table, view, incremental). The default one is view. This option can be overriden on each `.sql` file.

## Data Sources

- configure the source data only once in a `.yml` file
- we use the `source` function to reference to the source table from the `.yml`
- visualize the raw tables in the lineage on dbt Cloud UI

## Tests

The tests are data validations that are performed after the data is loaded to the warehouse. On `dbt` there are two types of tests:

- singular tests:
  - they are defined as a `.sql` file inside the `tests` directory
  - super specific tests that are olny valid for one model in particular
- generic tests:
    they are defined on a `.yml` file inside the `models` directory, for particular tables/columns
  - unique
  - not null
  - accepted_values
  - relationships
- you can also test the source tables, by adding the generic tests on the source .yml, or by creaeting the custom `.sql` query on `tests` directory
- additional testing can be imported through packages or write ypur custom generic tests
- Execute `dbt test --profiles-dir .` to run all generic and singular tests in your project.
- Execute `dbt test --select test_type:generic --profiles-dir .` to run only generic tests in your project.
- Execute `dbt test --select test_type:singular --profiles-dir .` to run only singular tests in your project.
- Execute `dbt test --select one_specific_model --profiles-dir .` to run only one specific model

## Documentation

- doc blocks: you can use only on doc block per `.md` file, or many doc blocks on one single `.md` file.

```
{% docs NAME %}
description
...
{% enddocs %}
```

you have to create a `.md` file with the documentation, and then reference it on the `model.yml` file, for example: `description: "{{ doc('order_status') }}"`
to generate the docs, execute:

```
dbt docs generate --profiles-dir .
```

This command will create a `index.html` file on `target` directory.

We can run a `nginx` server to expose this webpage to see the data documentation (run this from inside `dbt-postgres/dbt_findamentals/jaffle_shop` directory). This will use the [dockersamples/static-site](https://hub.docker.com/r/dockersamples/static-site/) Docker image.

```
$ docker run --name dbt_docs --rm /
-d -v $PWD/target:/usr/share/nginx/html /
-p 8888:80 dockersamples/static-site

$ dbt docs generate --profiles-dir .
```

This will generate the docs webpage available on `localhost:8888`, where we can see the all the define documentation, the dependencies, the lineage graph, and everything we need to make all the data model much more clear.


## Deployment


