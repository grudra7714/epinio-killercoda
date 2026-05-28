# Manage Your Application

Epinio provides commands to monitor and manage your running applications.

## View Application Logs

Check the application logs:

```bash
epinio app logs sample
```{{exec}}

You can also view the staging (build) logs:

```bash
epinio app logs --staging sample
```{{exec}}

## Scale the Application

Scale your application to 3 instances for higher availability:

```bash
epinio app update sample --instances 3
```{{exec}}

Verify the scaling:

```bash
epinio app show sample
```{{exec}}

You should see `3/3` under the status, indicating all 3 instances are running.

## Set Environment Variables

Configure your application with environment variables:

```bash
epinio app env set sample MY_VAR "Hello from Epinio"
```{{exec}}

List environment variables:

```bash
epinio app env list sample
```{{exec}}

## Scale Back Down

Scale back to a single instance:

```bash
epinio app update sample --instances 1
```{{exec}}

Confirm the change:

```bash
epinio app list
```{{exec}}
