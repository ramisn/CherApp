# frozen_string_literal: true

LiveFactor.find_or_create_by!(question: 'Would your friends consider you a neat person?',
                              weight: 5,
                              start_label: 'I can never find anything.',
                              end_label: 'Did you just drop that?')

LiveFactor.find_or_create_by!(question: 'Do you spend time reflecting on things?',
                              weight: 5,
                              start_label: 'No regrets, I move on.',
                              end_label: 'Whoops, just zoned out.')

LiveFactor.find_or_create_by!(question: 'Do you get chores done right away?',
                              weight: 4,
                              start_label: 'If I get nagged enough.',
                              end_label: "Sorry, I can't hear you over the vacuum.")

LiveFactor.find_or_create_by!(question: 'Do you consider others when making decisions?',
                              weight: 3,
                              start_label: 'Nope, gotta look out for #1.',
                              end_label: 'Depends on how you feel about it.')

LiveFactor.find_or_create_by!(question: 'Are you open to upkeep, repairs and improvements to your home?',
                              weight: 5,
                              start_label: 'not my job, sorry!',
                              end_label: "Where's my toolbelt?")

LiveFactor.find_or_create_by!(question: 'Are you a quiet person?',
                              weight: -1,
                              start_label: "Don't touch my drumset",
                              end_label: '*silence intensifies*')

LiveFactor.find_or_create_by!(question: 'How often do you have friends over?',
                              weight: -3,
                              start_label: 'Never. My home is my sanctuary.',
                              end_label: "They're in the other room.")

LiveFactor.find_or_create_by!(question: 'How easily do you get irritated?',
                              weight: -3,
                              start_label: 'Only good vibes.',
                              end_label: 'Why so many questions?!')

LiveFactor.find_or_create_by!(question: 'Would living with someone that works from home bother you?',
                              weight: -4,
                              start_label: 'More power to them.',
                              end_label: "Don't you ever leave the house?")

LiveFactor.find_or_create_by!(question: 'Do you think you’re a moody person?',
                              weight: -4,
                              start_label: "Feelings? I don't understand.",
                              end_label: "Depends on the time of day and if I've eaten.")

LiveFactor.find_or_create_by!(question: 'Are you comfortable living with pets?',
                              weight: 5,
                              start_label: 'I only like humans.',
                              end_label: 'Most of my friends are animals.')

LiveFactor.find_or_create_by!(question: 'How strongly do you identify with a religion?',
                              weight: 5,
                              start_label: 'Meh.',
                              end_label: "I'm installing an altar.")

LiveFactor.find_or_create_by!(question: 'How strongly do you identify with a political party?',
                              weight: 5,
                              start_label: "Can't remember if I voted.",
                              end_label: 'You should see my bumperstickers.')

LiveFactor.find_or_create_by!(question: 'How do you feel about smoking?',
                              weight: 5,
                              start_label: 'can you please put that out',
                              end_label: 'do you have a light? / Does Juul count?')

LiveFactor.find_or_create_by!(question: 'How comfortable are you living with someone significantly older or younger?',
                              weight: 5,
                              start_label: "It's all about how old you act.",
                              end_label: 'Age is the great divide.')

LiveFactor.find_or_create_by!(question: 'How long do you plan on owning your new home?',
                              weight: 5,
                              start_label: "What's the minimum?",
                              end_label: 'Bury me in the backyard.')

CA_CITIES = ['Adelanto', 'Agoura Hills', 'Alameda', 'Albany', 'Alhambra', 'Aliso Viejo', 'Alturas', 'Amador City',
             'American Canyon', 'Anaheim', 'Anderson', 'Angels Camp', 'Antioch', 'Arcadia', 'Arcata', 'Arroyo Grande',
             'Artesia', 'Arvin', 'Atascadero', 'Atwater', 'Auburn', 'Avalon', 'Avenal', 'Azusa', 'Bakersfield',
             'Baldwin Park', 'Banning', 'Barstow', 'Beaumont', 'Bell', 'Bell Gardens', 'Bellflower', 'Belmont',
             'Belvedere', 'Benicia', 'Berkeley', 'Beverly Hills', 'Big Bear Lake', 'Biggs', 'Bishop', 'Blue Lake',
             'Blythe', 'Bradbury', 'Brawley', 'Brea', 'Brentwood', 'Brisbane', 'Buellton', 'Buena Park', 'Burbank',
             'Burlingame', 'Calabasas', 'Calexico', 'California City', 'Calimesa', 'Calipatria', 'Calistoga',
             'Camarillo', 'Campbell', 'Canyon Lake', 'Capitola', 'Carlsbad', 'Carmel-by-the-Sea', 'Carpinteria',
             'Carson', 'Cathedral City', 'Ceres', 'Cerritos', 'Chico', 'Chino', 'Chino Hills', 'Chowchilla',
             'Chula Vista', 'Citrus Heights', 'Claremont', 'Clayton', 'Clearlake', 'Cloverdale', 'Clovis', 'Coachella',
             'Coalinga', 'Colfax', 'Colton', 'Colusa', 'Commerce', 'Compton', 'Concord', 'Corcoran', 'Corning',
             'Corona', 'Coronado', 'Costa Mesa', 'Cotati', 'Covina', 'Crescent City', 'Cudahy', 'Culver City',
             'Cupertino', 'Cypress', 'Daly City', 'Dana Point', 'Davis', 'Del Mar', 'Del Rey Oaks', 'Delano',
             'Desert Hot Springs', 'Diamond Bar', 'Dinuba', 'Dixon', 'Dorris', 'Dos Palos', 'Downey', 'Duarte',
             'Dublin', 'Dunsmuir', 'East Palo Alto', 'Eastvale', 'El Cajon', 'El Centro', 'El Cerrito', 'El Monte',
             'El Segundo', 'Elk Grove', 'Emeryville', 'Encinitas', 'Escalon', 'Escondido', 'Etna', 'Eureka', 'Exeter',
             'Fairfield', 'Farmersville', 'Ferndale', 'Fillmore', 'Firebaugh', 'Folsom', 'Fontana', 'Fort Bragg',
             'Fort Jones', 'Fortuna', 'Foster City', 'Fountain Valley', 'Fowler', 'Fremont', 'Fresno', 'Fullerton',
             'Galt', 'Garden Grove', 'Gardena', 'Gilroy', 'Glendale', 'Glendora', 'Goleta', 'Gonzales', 'Grand Terrace',
             'Grass Valley', 'Greenfield', 'Gridley', 'Grover Beach', 'Guadalupe', 'Gustine', 'Half Moon Bay', 'Hanford',
             'Hawaiian Gardens', 'Hawthorne', 'Hayward', 'Healdsburg', 'Hemet', 'Hercules', 'Hermosa Beach', 'Hesperia',
             'Hidden Hills', 'Highland', 'Hollister', 'Holtville', 'Hughson', 'Huntington Beach', 'Huntington Park',
             'Huron', 'Imperial', 'Imperial Beach', 'Indian Wells', 'Indio', 'Industry', 'Inglewood', 'Ione', 'Irvine',
             'Irwindale', 'Isleton', 'Jackson', 'Jurupa Valley', 'Kerman', 'King City', 'Kingsburg',
             'La Cañada Flintridge', 'La Habra', 'La Habra Heights', 'La Mesa', 'La Mirada', 'La Palma', 'La Puente',
             'La Quinta', 'La Verne', 'Lafayette', 'Laguna Beach', 'Laguna Hills', 'Laguna Niguel', 'Laguna Woods',
             'Lake Elsinore', 'Lake Forest', 'Lakeport', 'Lakewood', 'Lancaster', 'Larkspur', 'Lathrop', 'Lawndale',
             'Lemon Grove', 'Lemoore', 'Lincoln', 'Lindsay', 'Live Oak', 'Livermore', 'Livingston', 'Lodi',
             'Loma Linda', 'Lomita', 'Lompoc', 'Long Beach', 'Los Alamitos', 'Los Altos', 'Los Angeles', 'Los Banos',
             'Loyalton', 'Lynwood', 'Madera', 'Malibu', 'Manhattan Beach', 'Manteca', 'Maricopa', 'Marina', 'Martinez',
             'Marysville', 'Maywood', 'McFarland', 'Mendota', 'Menifee', 'Menlo Park', 'Merced', 'Mill Valley',
             'Millbrae', 'Milpitas', 'Mission Viejo', 'Modesto', 'Monrovia', 'Montague', 'Montclair', 'Monte Sereno',
             'Montebello', 'Monterey', 'Monterey Park', 'Moorpark', 'Moreno Valley', 'Morgan Hill', 'Morro Bay',
             'Mount Shasta', 'Mountain View', 'Murrieta', 'Napa', 'National City', 'Needles', 'Nevada City', 'Newark',
             'Newman', 'Newport Beach', 'Norco', 'Norwalk', 'Novato', 'Oakdale', 'Oakland', 'Oakley', 'Oceanside',
             'Ojai', 'Ontario', 'Orange', 'Orange Cove', 'Orinda', 'Orland', 'Oroville', 'Oxnard', 'Pacific Grove',
             'Pacifica', 'Palm Desert', 'Palm Springs', 'Palmdale', 'Palo Alto', 'Palos Verdes Estates', 'Paramount',
             'Parlier', 'Pasadena', 'Paso Robles', 'Patterson', 'Perris', 'Petaluma', 'Pico Rivera', 'Piedmont',
             'Pinole', 'Pismo Beach', 'Pittsburg', 'Placentia', 'Placerville', 'Pleasant Hill', 'Pleasanton',
             'Plymouth', 'Point Arena', 'Pomona', 'Port Hueneme', 'Porterville', 'Portola', 'Poway', 'Rancho Cordova',
             'Rancho Cucamonga', 'Rancho Mirage', 'Rancho Palos Verdes', 'Rancho Santa Margarita', 'Red Bluff',
             'Redding', 'Redlands', 'Redondo Beach', 'Redwood City', 'Reedley', 'Rialto', 'Richmond', 'Ridgecrest',
             'Rio Dell', 'Rio Vista', 'Ripon', 'Riverbank', 'Riverside', 'Rocklin', 'Rohnert Park', 'Rolling Hills',
             'Rolling Hills Estates', 'Rosemead', 'Roseville', 'Sacramento', 'St. Helena', 'Salinas', 'San Bernardino',
             'San Bruno', 'San Carlos', 'San Clemente', 'San Diego', 'San Dimas', 'San Fernando', 'San Gabriel',
             'San Jacinto', 'San Joaquin', 'San Jose', 'San Juan Bautista', 'San Juan Capistrano', 'San Leandro',
             'San Luis Obispo', 'San Marcos', 'San Marino', 'San Mateo', 'San Pablo', 'San Rafael', 'San Ramon',
             'Sand City', 'Sanger', 'Santa Ana', 'Santa Barbara', 'Santa Clara', 'Santa Clarita', 'Santa Cruz',
             'Santa Fe Springs', 'Santa Maria', 'Santa Monica', 'Santa Paula', 'Santa Rosa', 'Santee', 'Saratoga',
             'Sausalito', 'Scotts Valley', 'Seal Beach', 'Seaside', 'Sebastopol', 'Selma', 'Shafter', 'Shasta Lake',
             'Sierra Madre', 'Signal Hill', 'Simi Valley', 'Solana Beach', 'Soledad', 'Solvang', 'Sonoma', 'Sonora',
             'South El Monte', 'South Gate', 'South Lake Tahoe', 'South Pasadena', 'South San Francisco', 'Stanton',
             'Stockton', 'Suisun City', 'Sunnyvale', 'Susanville', 'Sutter Creek', 'Taft', 'Tehachapi', 'Tehama',
             'Temecula', 'Temple City', 'Thousand Oaks', 'Torrance', 'Tracy', 'Trinidad', 'Tulare', 'Tulelake',
             'Turlock', 'Tustin', 'Twentynine Palms', 'Ukiah', 'Union City', 'Upland', 'Vacaville', 'Vallejo',
             'Ventura', 'Vernon', 'Victorville', 'Villa Park', 'Visalia', 'Vista', 'Walnut', 'Walnut Creek', 'Wasco',
             'Waterford', 'Watsonville', 'Weed', 'West Covina', 'West Hollywood', 'West Sacramento', 'Westlake Village',
             'Westminster', 'Westmorland', 'Wheatland', 'Whittier', 'Wildomar', 'Williams', 'Willits', 'Willows',
             'Winters', 'Woodlake', 'Woodland', 'Yorba Linda', 'Yreka', 'Yuba City', 'Yucaipa'].freeze
CA_CITIES.each do |city|
  Area.find_or_create_by!(name: city)
end

PromoCode.find_or_create_by!(name: '30CliquePremium', class_name: 'OneMonthTrial')
