from fastapi import FastAPI, Query, Path, HTTPException, status
import uvicorn
from uuid import UUID
from typing import Optional
from pydantic import BaseModel
import datetime
from enum import Enum
import json
import time

app = FastAPI(title="SpendWise API", description="API for SpendWise App")

class TransactionType(str, Enum):
    income = "Income"
    expense = "Expense"

class Transaction(BaseModel):
    id: int
    name: str
    type: TransactionType
    amount: float
    date: datetime.date
    details: Optional[str] = ""

class UpdateTransaction(BaseModel):
    id: Optional[int] = None
    name: str
    type: TransactionType
    amount: float
    date: datetime.date
    details: Optional[str] = ""

# db = {
#     # 1: Transaction(id=1, name="Salary", type="Income", amount=1750, date=datetime.date(2024, 1, 1)),
#     # 2: Transaction(id=2, name="Rent", type="Expense", amount=1000, date=datetime.date(2024, 1, 1)),
#     # 3: Transaction(id=3, name="Side Hustle", type="Income", amount=280, date=datetime.date(2024, 1, 1)),
#     # 4: Transaction(id=4, name="Groceries", type="Expense", amount=176.8, date=datetime.date(2024, 1, 1)),
# }

db = dict()

@app.get("/transaction/all", status_code=status.HTTP_200_OK)
def get_all_transactions():
    time.sleep(0.5)
    print("GET ALL: ", list(db.values()))
    return {
        "message": "Transactions retrieved successfully",
        "data": list(db.values())
    }
    # return db

@app.get("/transaction/{transaction_id}", status_code=status.HTTP_200_OK)
def get_transaction(transaction_id: int):
    if transaction_id not in db:
        print("ERROR: Transaction ID not found: ", transaction_id)
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Transaction ID not found")
    print("GET: ", db[transaction_id])
    return {
        "message": "Transaction retrieved successfully",
        "data": [db[transaction_id]]
    }

@app.post("/transaction/", status_code=status.HTTP_201_CREATED)
def create_transaction(transaction: Transaction):
    time.sleep(0.5)
    if transaction.id in db:
        print("ERROR: Transaction ID already exists: ", db[transaction.id])
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Transaction ID already exists")
    db[transaction.id] = transaction
    print("CREATE: ", db[transaction.id])
    return {
        "message": "Transaction created successfully",
        "data": [db[transaction.id]]
    }

@app.put("/transaction/{transaction_id}", status_code=status.HTTP_202_ACCEPTED)
def update_transaction(transaction_id: int, name: str, type: TransactionType, amount: float, date: datetime.date, details: Optional[str] = ""):
    time.sleep(0.5)
    if transaction_id not in db:
        print("ERROR: Transaction ID not found: ", transaction_id)
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Transaction ID not found")
    db[transaction_id] = Transaction(id=transaction_id, name=name, type=type, amount=amount, date=date, details=details)
    print("UPDATE: ", db[transaction_id])
    return {
        "message": "Transaction updated successfully",
        "data": [db[transaction_id]]
    }

@app.delete("/transaction/{transaction_id}", status_code=status.HTTP_202_ACCEPTED)
def delete_transaction(transaction_id: int):
    time.sleep(0.5)
    if transaction_id not in db:
        print("ERROR: Transaction ID not found: ", transaction_id)
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Transaction ID not found")
    trasaction = [db[transaction_id]]
    del db[transaction_id]
    print("DELETE: ", trasaction)
    return {
        "message": "Transaction deleted successfully",
        "data": trasaction
    }

@app.get("/")
def index():
    return {"Hello": "World!"}









if __name__ == "__main__":
    # cmd command: uvicorn main:app --reload
    uvicorn.run(app, host="127.0.0.1", reload=True)