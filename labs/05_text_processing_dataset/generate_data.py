import csv
import random

random.seed(7)
products = ["working_capital", "invoice_financing", "term_loan"]
statuses = ["approved", "rejected", "pending"]

with open("risk_applications.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow([
        "application_id", "product", "status",
        "exposure", "dpd", "score"
    ])

    for i in range(1, 10001):
        writer.writerow([
            i,
            random.choice(products),
            random.choices(statuses, weights=[50, 30, 20])[0],
            random.randint(1000, 200000),
            random.choices(
                [0, 5, 15, 30, 45, 60],
                weights=[55, 10, 10, 10, 10, 5]
            )[0],
            random.randint(400, 850)
        ])
