// philippineData.js - Contains data for Philippine locations and other reference data

// Philippine Barangays (Common barangays across different cities/municipalities)
export const philippineBarangays = [
  'Poblacion', 'San Jose', 'San Antonio', 'San Juan', 'Santa Maria', 'Santo Niño', 'Barangay 1', 'Barangay 2', 
  'Barangay 3', 'Barangay 4', 'Barangay 5', 'Barangay 6', 'Barangay 7', 'Barangay 8', 'Barangay 9', 'Barangay 10',
  'Bagong Silang', 'Bagong Pag-asa', 'Bagong Buhay', 'Malate', 'Ermita', 'Intramuros', 'Binondo', 'Quiapo',
  'Sampaloc', 'Santa Cruz', 'San Miguel', 'Tondo', 'San Nicolas', 'Manila', 'Makati', 'Mandaluyong', 'Marikina',
  'Pasig', 'Quezon City', 'Caloocan', 'Malabon', 'Navotas', 'Valenzuela', 'Las Piñas', 'Makati', 'Muntinlupa',
  'Parañaque', 'Pasay', 'Pateros', 'Taguig', 'Antipolo', 'Bacoor', 'Biñan', 'Cabuyao', 'Calamba', 'Carmona',
  'Dasmariñas', 'General Trias', 'Imus', 'Kawit', 'Laguna', 'Lipa', 'Los Baños', 'Lucena', 'Majayjay', 'Naic',
  'Noveleta', 'Rosario', 'San Pablo', 'Santa Rosa', 'Silang', 'Tagaytay', 'Talisay', 'Tanauan', 'Trece Martires',
  'Alicia', 'Angono', 'Baras', 'Binangonan', 'Cainta', 'Cardona', 'Jalajala', 'Morong', 'Pililla', 'Rodriguez',
  'San Mateo', 'Tanay', 'Teresa', 'Taytay', 'Barangka', 'Bayan-Bayanan', 'Concepcion', 'Dagat-Dagatan', 'Longos',
  'Maysilo', 'Panghulo', 'Potrero', 'Sangandaan', 'Tonsuya', 'Tubigan', 'Bagbaguin', 'Bagong Barrio', 'Bignay',
  'Bisig', 'Canumay East', 'Canumay West', 'Coloong', 'Dalandanan', 'Gen. T. de Leon', 'Isla', 'Karuhatan',
  'Lawang Bato', 'Lingunan', 'Mabolo', 'Malanday', 'Malinta', 'Mapulang Lupa', 'Marulas', 'Maysan', 'Palasan',
  'Parada', 'Pariancillo Villa', 'Paso de Blas', 'Poblacion', 'Polo', 'Punturin', 'Rincon', 'Tagalag', 'Ugong',
  'Viente Reales', 'Wawang Pulo', 'Arkong Bato', 'Bagbag', 'Balangkas', 'Bignay', 'Canumay', 'Catmon', 'Coloong',
  'Dalandanan', 'Fish Port', 'Hulong Duhat', 'Isla', 'Longos', 'Maysilo', 'Muzon', 'Panghulo', 'Poblacion',
  'Potrero', 'Rincon', 'Sangandaan', 'Tonsuya', 'Tanza', 'Tubigan', 'Ugong Norte', 'Ugong Sur',
  
  // Region 9 (Zamboanga Peninsula) - Comprehensive barangay list
  // Zamboanga City barangays
  'Ayala', 'Baliwasan', 'Boalan', 'Bolong', 'Buenavista', 'Bunguiao', 'Busay', 'Cabaluay', 'Cabatangan', 'Cacao',
  'Calabasa', 'Calarian', 'Camino Nuevo', 'Campo Islam', 'Canelar', 'Capisan', 'Caputian', 'Cawit', 'Culianan',
  'Curuan', 'Divisoria', 'Dulian', 'Guisao', 'Guiwan', 'La Paz', 'Labuan', 'Lamisahan', 'Landang Gua', 'Landang Laum',
  'Lapakan', 'Latuan', 'Limaong', 'Limpapa', 'Lubigan', 'Lumayang', 'Lunzuran', 'Maasin', 'Malagutay', 'Manicahan',
  'Mariki', 'Mercedes', 'Muti', 'Pamucutan', 'Pangapuyan', 'Pasonanca', 'Patalon', 'Putik', 'Quiniput', 'Rio Hondo',
  'Salaan', 'San Jose Cawa', 'San Jose Gusu', 'San Roque', 'Sangali', 'Santa Barbara', 'Santa Catalina', 'Santa Maria',
  'Sinubung', 'Sinunoc', 'Suterville', 'Tagasilay', 'Taguiti', 'Talabaan', 'Taluksangay', 'Talon-Talon', 'Tictapul',
  'Tigbalabag', 'Tolosa', 'Tumaga', 'Tumitus', 'Victoria', 'Vitali', 'Yakan Village', 'Zambowood',
  
  // Pagadian City barangays
  'Balangasan', 'Balintawak', 'Banale', 'Banga', 'Bomba', 'Bogo', 'Bulatok', 'Canaway', 'Danlugan', 'Datagan',
  'Gatas', 'Gubac', 'Kagawasan', 'Kawit', 'Lacanan', 'Lala', 'Lenienza', 'Lizon Valley', 'Lower Sibatang',
  'Macasing', 'Muricay', 'Napolan', 'Palpalan', 'San Francisco', 'San Pedro', 'Santiago', 'Santo Niño', 'Tiguma',
  'Tuyoron', 'Upper Sibatang', 'White Beach',
  
  // Dipolog City barangays
  'Barra', 'Biasong', 'Central', 'Cogon', 'Dicayas', 'Diwan', 'Estaka', 'Galas', 'Gulayon', 'Lugdungan',
  'Miputak', 'Napo', 'Olingan', 'Pag-asa', 'Pangabuan', 'Santa Isabel', 'Sicayab', 'Sinaman', 'Sta. Filomena',
  'Turno', 'Unhawan',
  
  // Dapitan City barangays
  'Aliguay', 'Ba-ao', 'Bagacay', 'Bagting', 'Barcelona', 'Baylimango', 'Burgos', 'Carang', 'Cawa-Cawa',
  'Dawo', 'Dapitan', 'Derilon', 'Liboron', 'Masidlakon', 'Opao', 'Polo', 'Potol', 'San Nicolas', 'San Pedro',
  'San Vicente', 'Santa Cruz', 'Siayan', 'Sulangon', 'Talisay', 'Tomasa', 'Tulawan', 'Vila',
  
  // Isabela City barangays
  'Baluno', 'Binuangan', 'Cabunbata', 'Calvario', 'Isabela Proper', 'Kaumpurnah', 'Kumalarang', 'Lampinigan',
  'Lukbuton', 'Malamawi', 'Maluso', 'Marang-Marang', 'Menzi', 'Panigayan', 'Santa Barbara', 'Small Kalamansig',
  'Sumagdang', 'Tabuk', 'Tabiawan', 'Tampalan'
].sort();

// Philippine Cities and Municipalities (Major cities and municipalities)
export const philippineCities = [
  // National Capital Region (NCR)
  'Manila', 'Quezon City', 'Makati', 'Pasig', 'Taguig', 'Marikina', 'Mandaluyong', 'San Juan', 'Muntinlupa',
  'Las Piñas', 'Parañaque', 'Pasay', 'Caloocan', 'Malabon', 'Navotas', 'Valenzuela', 'Pateros',

  // Region I (Ilocos Region)
  'Dagupan', 'San Carlos', 'Alaminos', 'Urdaneta', 'Laoag', 'Batac', 'Candon', 'Vigan', 'Agoo', 'Bauang',
  'Naguilian', 'San Fernando', 'San Juan', 'Alaminos', 'Bolinao', 'Bugallon', 'Calasiao', 'Dasol', 'Infanta',
  'Labrador', 'Lingayen', 'Mabini', 'Malasiqui', 'Manaoag', 'Mangaldan', 'Mangatarem', 'Mapandan', 'Natividad',
  
  // Region II (Cagayan Valley)
  'Tuguegarao', 'Cauayan', 'Ilagan', 'Santiago', 'Tabuk', 'Lamut', 'Bayombong', 'Solano',
  
  // Region III (Central Luzon)
  'San Jose del Monte', 'Malolos', 'Meycauayan', 'Marilao', 'Bocaue', 'Balagtas', 'Guiguinto', 'Hagonoy',
  'Paombong', 'Pulilan', 'Calumpit', 'Plaridel', 'San Rafael', 'Angat', 'Bustos', 'San Ildefonso', 'San Miguel',
  'Doña Remedios Trinidad', 'Norzagaray', 'Santa Maria', 'Pandi', 'Obando', 'Bulakan', 'San Jose', 'Balanga',
  'Dinalupihan', 'Hermosa', 'Limay', 'Mariveles', 'Morong', 'Orani', 'Orion', 'Pilar', 'Samal', 'Bagac',
  'Abucay', 'Olongapo', 'Subic', 'Castillejos', 'San Antonio', 'San Felipe', 'San Marcelino', 'San Narciso',
  'Botolan', 'Cabangan', 'Candelaria', 'Iba', 'Masinloc', 'Palauig', 'Santa Cruz', 'Angeles', 'San Fernando',
  'Mabalacat', 'Porac', 'Floridablanca', 'Guagua', 'Lubao', 'Sasmuan', 'Macabebe', 'Masantol', 'Mexico',
  'Santa Ana', 'Arayat', 'Candaba', 'San Luis', 'San Simon', 'Santo Tomas', 'Bacolor', 'Minalin', 'Cabanatuan',
  'Gapan', 'San Jose', 'Palayan', 'Muñoz', 'Talavera', 'Aliaga', 'Bongabon', 'Cabiao', 'Carranglan', 'Cuyapo',
  'Gabaldon', 'General Mamerto Natividad', 'General Tinio', 'Guimba', 'Jaen', 'Laur', 'Licab', 'Llanera',
  'Lupao', 'Nampicuan', 'Pantabangan', 'Peñaranda', 'Quezon', 'Rizal', 'San Antonio', 'San Isidro', 'San Leonardo',
  'Santa Rosa', 'Santo Domingo', 'Zaragoza', 'Tarlac', 'Concepcion', 'Capas', 'Bamban', 'Camiling', 'Gerona',
  'La Paz', 'Paniqui', 'Moncada', 'San Carlos', 'San Jose', 'Santa Ignacia', 'Victoria', 'Ramos', 'Mayantoc',
  'San Clemente', 'Pura', 'Anao', 'San Manuel',
  
  // Region IV-A (CALABARZON)
  'Antipolo', 'Bacoor', 'Biñan', 'Cabuyao', 'Calamba', 'Carmona', 'Dasmariñas', 'General Trias', 'Imus',
  'Kawit', 'Laguna', 'Lipa', 'Los Baños', 'Lucena', 'Majayjay', 'Naic', 'Noveleta', 'Rosario', 'San Pablo',
  'Santa Rosa', 'Silang', 'Tagaytay', 'Talisay', 'Tanauan', 'Trece Martires', 'Cavite City', 'Tagaytay',
  'Bacoor', 'Imus', 'Dasmariñas', 'Carmona', 'General Trias', 'Trece Martires', 'Cavite City', 'Kawit',
  'Noveleta', 'Rosario', 'Tanza', 'Naic', 'Maragondon', 'Ternate', 'Magallanes', 'Alfonso', 'Amadeo',
  'General Emilio Aguinaldo', 'Indang', 'Mendez', 'Silang', 'Tagaytay', 'Calamba', 'Biñan', 'Santa Rosa',
  'Cabuyao', 'San Pablo', 'Tanauan', 'Lipa', 'Santo Tomas', 'Alaminos', 'Batangas City', 'Lemery', 'Taal',
  'Cuenca', 'Ibaan', 'Taysan', 'Lobo', 'Batangas', 'Bauan', 'San Pascual', 'Tingloy', 'Calatagan', 'Balayan',
  'Calaca', 'Laurel', 'Agoncillo', 'Malvar', 'Mataasnakahoy', 'Padre Garcia', 'Rosario', 'San Jose', 'San Juan',
  'San Luis', 'Santa Teresita', 'Talisay', 'Tuy', 'Nasugbu', 'Lian', 'Calatagan', 'Lemery', 'Taal', 'San Nicolas',
  'Sta. Teresita', 'Mabini', 'Lucena', 'Tayabas', 'Sariaya', 'Candelaria', 'Dolores', 'Tiaong', 'San Antonio',
  'Lucban', 'Sampaloc', 'Padre Burgos', 'Quezon', 'Pagbilao', 'Atimonan', 'Plaridel', 'Gumaca', 'Lopez',
  'Calauag', 'Guinayangan', 'Tagkawayan', 'Buenavista', 'Catanauan', 'General Luna', 'Macalelon', 'Mulanay',
  'San Andres', 'San Francisco', 'San Narciso', 'Unisan', 'Agdangan', 'Alabat', 'Perez', 'Pitogo', 'Cainta',
  'Taytay', 'Angono', 'Binangonan', 'Cardona', 'Morong', 'Baras', 'Tanay', 'Pililla', 'Jalajala', 'Rodriguez',
  'San Mateo', 'Teresa',
  
  // Region IV-B (MIMAROPA)
  'Puerto Princesa', 'Calapan', 'Mamburao', 'Boac', 'Romblon', 'Odiongan',
  
  // Region V (Bicol Region)
  'Naga', 'Iriga', 'Legazpi', 'Ligao', 'Tabaco', 'Masbate', 'Sorsogon', 'Virac',
  
  // Region VI (Western Visayas)
  'Iloilo City', 'Bacolod', 'Roxas', 'Kalibo', 'San Jose de Buenavista', 'Boracay',
  
  // Region VII (Central Visayas)
  'Cebu City', 'Mandaue', 'Lapu-Lapu', 'Talisay', 'Toledo', 'Danao', 'Carcar', 'Bogo', 'Dumaguete', 'Bais',
  'Bayawan', 'Canlaon', 'Guihulngan', 'Tanjay', 'Tagbilaran', 'Ubay',
  
  // Region VIII (Eastern Visayas)
  'Tacloban', 'Ormoc', 'Baybay', 'Maasin', 'Calbayog', 'Catbalogan', 'Borongan',
  
  // Region IX (Zamboanga Peninsula)  
  'Zamboanga City', 'Pagadian', 'Dipolog', 'Dapitan', 'Isabela',
  
  // Region X (Northern Mindanao)
  'Cagayan de Oro', 'Iligan', 'Butuan', 'Malaybalay', 'Valencia', 'Oroquieta', 'Ozamiz', 'Tangub', 'Tubod',
  'Gingoog', 'Balingoan', 'Jasaan', 'Villanueva', 'Tagoloan', 'Laguindingan', 'Gitagum', 'Medina', 'Salay',
  'Binuangan', 'Catarman', 'Guinsiliban', 'Mahinog', 'Mambajao', 'Sagay',
  
  // Region XI (Davao Region)
  'Davao City', 'Tagum', 'Panabo', 'Samal', 'Digos', 'Mati',
  
  // Region XII (SOCCSKSARGEN)
  'General Santos', 'Koronadal', 'Tacurong', 'Kidapawan', 'Cotabato City', 'Surallah',
  
  // Region XIII (Caraga)
  'Butuan', 'Surigao City', 'Tandag', 'Bislig', 'Bayugan',
  
  // Cordillera Administrative Region (CAR)
  'Baguio', 'Tabuk', 'Lamut', 'Bontoc', 'Sagada', 'Mayoyao', 'Lagawe',
  
  // Autonomous Region in Muslim Mindanao (ARMM) - now BARMM
  'Cotabato City', 'Marawi', 'Lamitan', 'Jolo', 'Bongao'
].sort();

// Common Citizenships (Philippines and International)
export const citizenshipOptions = [
  // Southeast Asian Countries
  'Filipino', 'Philippine', 'Indonesian', 'Malaysian', 'Singaporean', 'Thai', 'Vietnamese', 'Cambodian', 
  'Laotian', 'Bruneian', 'Myanmar', 'Burmese',
  
  // East Asian Countries
  'Chinese', 'Japanese', 'Korean', 'South Korean', 'North Korean', 'Taiwanese', 'Mongolian', 'Hong Kong',
  
  // South Asian Countries  
  'Indian', 'Pakistani', 'Bangladeshi', 'Sri Lankan', 'Nepalese', 'Bhutanese', 'Maldivian', 'Afghan',
  
  // Middle Eastern Countries
  'Saudi Arabian', 'Emirati', 'Qatari', 'Kuwaiti', 'Bahraini', 'Omani', 'Yemeni', 'Jordanian', 'Lebanese',
  'Syrian', 'Iraqi', 'Iranian', 'Turkish', 'Israeli', 'Palestinian',
  
  // European Countries
  'British', 'English', 'Scottish', 'Welsh', 'Irish', 'French', 'German', 'Italian', 'Spanish', 'Portuguese',
  'Dutch', 'Belgian', 'Swiss', 'Austrian', 'Swedish', 'Norwegian', 'Danish', 'Finnish', 'Polish', 'Czech',
  'Slovak', 'Hungarian', 'Romanian', 'Bulgarian', 'Croatian', 'Serbian', 'Bosnian', 'Montenegrin', 'Albanian',
  'Greek', 'Cypriot', 'Maltese', 'Luxembourgish', 'Estonian', 'Latvian', 'Lithuanian', 'Slovenian', 'Ukrainian',
  'Belarusian', 'Moldovan', 'Russian',
  
  // North American Countries
  'American', 'Canadian', 'Mexican', 'Guatemalan', 'Belizean', 'Salvadoran', 'Honduran', 'Nicaraguan',
  'Costa Rican', 'Panamanian',
  
  // South American Countries
  'Brazilian', 'Argentine', 'Chilean', 'Peruvian', 'Colombian', 'Venezuelan', 'Ecuadorian', 'Bolivian',
  'Paraguayan', 'Uruguayan', 'Guyanese', 'Surinamese',
  
  // African Countries
  'South African', 'Egyptian', 'Moroccan', 'Algerian', 'Tunisian', 'Libyan', 'Nigerian', 'Ghanaian',
  'Kenyan', 'Ethiopian', 'Sudanese', 'Ugandan', 'Tanzanian', 'Rwandan', 'Burundian', 'Congolese',
  'Zambian', 'Zimbabwean', 'Botswanan', 'Namibian', 'Malawian', 'Mozambican', 'Madagascan', 'Mauritian',
  'Seychellois', 'Senegalese', 'Malian', 'Burkinabe', 'Ivorian', 'Gabonese', 'Cameroonian', 'Chadian',
  
  // Oceania Countries
  'Australian', 'New Zealand', 'Fijian', 'Samoan', 'Tongan', 'Papua New Guinean', 'Solomon Islander',
  'Vanuatuan', 'Palauan', 'Marshallese', 'Micronesian', 'Nauruan', 'Kiribati', 'Tuvaluan',
  
  // Caribbean Countries
  'Jamaican', 'Cuban', 'Dominican', 'Haitian', 'Puerto Rican', 'Trinidadian', 'Tobagonian', 'Barbadian',
  'Bahamian', 'Antiguan', 'Barbudan', 'Saint Lucian', 'Grenadian', 'Saint Vincentian', 'Grenadine',
  
  // Additional Common Terms
  'Dual Citizen', 'Stateless', 'Refugee', 'Asylum Seeker'
].sort();

// Other constants can be added here as needed
