-- 1. samakan DATA dari kedua tabel;

SELECT * from covidprojectporto.coviddeaths 
ORDER BY 1
 
 SELECT * from covidprojectporto.covidvaksin
ORDER BY 1

-- 2. pilih DATA yang akan kita gunakan

SELECT dataid, locations,DATE,population,totalCases,totaldeaths
 from coviddeaths
 ORDER BY 2,3
--  
 -- 3. mencari DATA di totalcases vs totaldeaths
SELECT locations,date,totalCases,totaldeaths, (totaldeaths/totalcases)*100 AS deathspercentage
 from coviddeaths
 ORDER BY totalcases desc

-- 4. cari DATA tahun 2023
 SELECT distinct locations,date,totalCases,totaldeaths, (totaldeaths/totalcases)*100 AS deathspercentage
  from coviddeaths
  WHERE YEAR (DATE) = 2023
  ORDER BY totalcases desc
 
--  5. cari DATA totalcases dan populasi yang terkena covid
 SELECT distinct locations,date,totalCases,totaldeaths,population, (totalcases/population)*100 AS percentageinfected
  from coviddeaths
 ORDER BY totalcases desc

-- 6. cari negara yang paling tinggi dan terendah tingkat infeksi dan bandingkan dengan population
-- setelah agregasi harus pakai group by

 SELECT locations, MAX(totalCases) AS infeksitertinggi ,population, 
 MAX((totalcases/population))*100 AS percentageinfected
  from coviddeaths
  GROUP BY locations,population
  ORDER BY percentageinfected
 
 SELECT
   locations,
   MIN(totalCases) AS infeksitertinggi,
   population,
   MIN((totalCases / population)) * 100 AS percentageinfected
 FROM
   coviddeaths
 GROUP BY
   locations, population;
  ORDER BY percentageinfected

 -- 7. cari data kematian covid tertinggi dari negara-negara per population
 
SELECT locations, max(totaldeaths), population, MAX((totaldeaths/population))*100 AS percentagekematian
 from coviddeaths
 WHERE locations NOT IN ('asia','africa')
 GROUP BY locations,population
 ORDER BY locations,percentagekematian DESC 
 
SELECT locations, max(totaldeaths) AS totalkematian
from coviddeaths
GROUP BY locations
ORDER BY locations DESC 

-- 8 cari total kematian tertinggi di setiap benua

 SELECT continent, MAX(totaldeaths) AS totalkematian 
 FROM coviddeaths
 WHERE continent IS NOT NULL 
 GROUP BY continent
 ORDER BY continent

 9. join kedua tabel coviddeaths dan covidvaksin 

SELECT * FROM coviddeaths 
JOIN covidvaksin 
ON coviddeaths.dataid = covidvaksin.dataid

-- 10 mencari data total population dan total vaksinasi 
 -- SOAL PARTISI ; Jadi, 
-- secara keseluruhan, pernyataan tersebut menghitung jumlah total vaksin untuk setiap baris data, 
-- tetapi jumlah tersebut dihitung secara terpisah untuk setiap "partisi" berdasarkan nilai kolom locations. 
-- Dengan kata lain, jumlah total vaksin dihitung secara independen untuk setiap lokasi yang berbeda.
-- Contoh praktisnya mungkin adalah jika Anda memiliki data vaksinasi untuk beberapa lokasi, 
-- fungsi ini dapat memberi Anda total vaksinasi terkumpul untuk setiap lokasi, 
-- dan bukan hanya total keseluruhan di seluruh tabel.

SELECT (covidvaksin.locations),covidvaksin.DATE, population, totalvaksin, peoplevaksin, 
SUM(totalvaksin) OVER (PARTITION BY covidvaksin.locations) AS sort
FROM covidvaksin
JOIN coviddeaths
ON covidvaksin.dataid = coviddeaths.dataid
ORDER BY 1,2

-- CTE 
WITH (locations,DATE,population,totalvaksin,peoplevaksin,sort) 
AS
(
SELECT (covidvaksin.locations),covidvaksin.DATE, population, totalvaksin, peoplevaksin, 
SUM(totalvaksin) OVER (PARTITION BY covidvaksin.locations) AS sort
FROM covidvaksin
JOIN coviddeaths
ON covidvaksin.dataid = coviddeaths.dataid
)






                                   







