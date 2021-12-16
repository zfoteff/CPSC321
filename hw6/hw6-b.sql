/**********************************************************************
 * NAME:        Zac Foteff
 * CLASS:       CPSC321: Database Management Systems
 * DATE:        10/24/2021
 * HOMEWORK:    HW6
 * DESCRIPTION: Queries on the ongoing Lego database example from 
                previous homeworks
 **********************************************************************/
-- Select statements for Lego table queries
-- 2(a)
SELECT DISTINCT
    l.item_num,
    l.set_name
FROM
    LegoSets as l JOIN 
    PartsList as p ON (p.item_num=l.item_num)
WHERE
    (l.price < 25.00) and
    (p.num_bricks > 10);

-- 2(b)
SELECT DISTINCT
    l.item_num,
    l.set_name
FROM 
    LegoSets as l JOIN
    PartsList as p ON (p.item_num=l.item_num) JOIN 
    Bricks as b ON (b.elem_id=p.elem_id)
WHERE
    (b.brick_color="Bright Blue" and b.brick_name="1x2 Brick") or 
    (b.brick_color="Bright Red" and b.brick_name="2x4 Plate");

-- 2(c)
SELECT DISTINCT
    l.item_num,
    l.set_name
FROM
    LegoSets as l JOIN
    Themes as t ON (l.theme_name=t.theme_name)
WHERE
    --  Instead of joining on a 'Disney' theme, I'm doing a join
    --  Over themes with the disney license, since there will be more results
    (t.license="Walt Disney Inc.");

--  2(d)
SELECT DISTINCT
    l.item_num,
    l.set_name
FROM
    LegoSets as l JOIN
    SetCategories as s ON (l.item_num=s.item_num)
WHERE
    (s.category_name="Sports") or
    (s.category_name="Building");

-- 2(e)
SELECT DISTINCT
    l.item_num,
    l.set_name
FROM
    LegoSets as l JOIN
    SetProductionYears as s1 ON (l.item_num=s1.item_num) JOIN
    SetProductionYears as s2 ON (l.item_num=s2.item_num)
WHERE
    (s1.prod_start_year<>s2.prod_start_year);

-- 2(f)
SELECT DISTINCT
    l.item_num,
    l.set_name
FROM    
    LegoSets as l
WHERE
    (l.minifig_count IS NOT NULL) and 
    (l.minifig_count > 4) and 
    (l.vip_points > 120);

-- 2(g)
SELECT DISTINCT
    l.item_num,
    l.set_name
FROM
    LegoSets as l JOIN
    SetProductionYears as s1 ON (l.item_num=s1.item_num) JOIN
    SetProductionYears as s2 ON (l.item_num=s2.item_num and s1.prod_start_year=s2.prod_start_year and s1.prod_end_year=s2.prod_end_year)
WHERE
    (s1.prod_end_year IS NOT NULL) and 
    (s2.prod_end_year IS NOT NULL);

-- 2(h)
-- Return all the parts is that make up the Jabba's palace set
SELECT DISTINCT
    l.item_num,
    l.set_name,
    b.brick_name,
    p.num_bricks
FROM
    LegoSets as l JOIN
    Bricks as b JOIN 
    PartsList as p ON p.item_num=l.item_num
WHERE
    l.set_name="Jabba's Palace" and
    p.elem_id=b.elem_id and 
    p.des_id=b.des_id;

-- Return sets with more than 50 of a part
SELECT DISTINCT
    l.item_num,
    b.brick_name,
    p.num_bricks
FROM
    LegoSets as l JOIN
    Bricks as b JOIN
    PartsList as p ON (p.item_num=l.item_num)
WHERE
    p.elem_id=b.elem_id and 
    p.des_id=b.des_id and
    p.num_bricks>50;

-- Return all bricks with multiple design id's
SELECT DISTINCT
    b1.elem_id,
    b1.des_id,
    b2.des_id
FROM 
    Bricks as b1 JOIN
    Bricks as b2 ON (b1.elem_id=b2.elem_id)
WHERE
    (b1.des_id<>b2.des_id);