# ADB Bank

1. Go to the **Actions** tab and select the latest Workflow.
2. Open the run and download **ADB-bank-apk** under *Artifacts*.
3. Unzip it and install `app-debug.apk` on your phone (allow "install unknown apps").

## Interest (v1.1)

- Your balance earns **10% APR**, credited **every day** (daily rate = 10% / 365, compounded daily).
- Interest is added at each midnight (local time). If the app was closed for a few days, the missed days are credited the next time you open it.
- Fractions of a cent are carried over, so small balances still earn correctly.
- Each credit shows in *Recent activity* as "Daily interest"; total earned is shown on the card.
- Existing accounts start earning from the day they update.
