import pymongo

connection_string = "mongodb+srv://tikape:NAq8a4pNLWF8TMfd@cluster0.u4vehy9.mongodb.net/"
client = pymongo.MongoClient(connection_string)

database = client.get_database("tikape")
apartments = database["apartments"]

# 1. Montako asuntoa postinumerolla 00700?

zip_count = apartments.count_documents({"zip_code":"00700"})

print(zip_count)

# 2. Montako asuntoa rakennettu 2000-luvulla?

apartment_count_2000s = apartments.count_documents({
    "construction_year": {"$gte":2000, "$lt":2100}})

print(apartment_count_2000s)

# 3. Montako asuntoa pinta-alaltaan 50–70 m²?

apartment_count_area_50_70 = apartments.count_documents({
    "apartment_size": {"$gte":50,"$lte":70}
})

print(apartment_count_area_50_70)

# 4. Kuinka monta asuntoa myyty ainakin kerran vuosina 2010–2012?

apartment_sold_2010_2012_count = apartments.count_documents({
    "transactions": {
        "$elemMatch": {
            "date": {"$gte": "2010-01-01","$lte":"2012-12-31"}
        }
    }
})

print(apartment_sold_2010_2012_count)

# 5. Mikä on kallein myyntihinta koko aineistossa?

max_price = 0

for apartment in apartments.find({},{"transactions.selling_price":1}):
    if "transactions" in apartment:
        for transaction in apartment["transactions"]:
            if transaction["selling_price"] > max_price:
                max_price = transaction["selling_price"]

print(max_price)