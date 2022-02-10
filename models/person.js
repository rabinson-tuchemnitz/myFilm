const pool = require('../db');

const getBasicPersonList = async () => {
    queryResult = await pool.query('SELECT * FROM get_basic_person_list()');

    return queryResult.rows;
}

const getPersonList = async () => {
    queryResult = await pool.query('SELECT * FROM get_person_list()');

    return queryResult.rows;
}

const getPersonById = async (person_id) => {
    queryResult = await pool.query('SELECT * FROM get_person_by_id($1)',[person_id]);

    return queryResult.rows[0];
}

const storePerson  = async (name, dob, country, role, description, gender) => {
    queryResult = await pool.query(
        `SELECT insert_person(name:=$1, dob:=$2, gender:=$3, nationality:=$4, role:=$5, description:=$6)`    
        ,[name, dob, gender, country, role, description]
        );

    return queryResult.rows;
}

const updatePerson  = async (userId, name, dob, country, role, description, gender) => {
    queryResult = await pool.query(
        `SELECT update_person(
            inp_personId:=$1, 
            inp_name:=$2,
            inp_dob:=$3,
            inp_gender:=$4,
            inp_nationality:=$5, 
            inp_role:=$6, 
            inp_description:=$7
        )`    
        ,[userId, name, dob, gender, country, role, description]
        );

    return queryResult.rows;
}

const deletePerson = async (person_id) => {
    queryResult = await pool.query('SELECT * FROM delete_person($1)',[person_id]);

    return queryResult.rows;
}



module.exports = {
    getBasicPersonList,
    getPersonList,
    getPersonById,
    storePerson,
    updatePerson,
    deletePerson
}