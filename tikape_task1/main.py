import bikes

print("Test 1:", bikes.distance_of_user("ocuber"))
print("Test 2:", bikes.speed_of_user("ocuber"))
print("Test 3:", bikes.duration_in_each_city("2021-06-01"))
print("Test 4:", bikes.users_in_city("laeserii"))
print("Test 5:", bikes.trips_on_each_day("laeserii"))
print("Test 6:", bikes.most_popular_start("laeserii"))

print("Arvostelu:")
print("Test 1:", bikes.distance_of_user("eba"))
print("Test 2:", bikes.speed_of_user("eba"))
print("Test 3:", bikes.duration_in_each_city("2021-06-15"))
print("Test 4:", bikes.users_in_city("anddesen"))
print("Test 5:", bikes.trips_on_each_day("anddesen"))
print("Test 6:", bikes.most_popular_start("anddesen"))