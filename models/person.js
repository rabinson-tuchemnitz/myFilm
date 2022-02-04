const pool = require('../db');

const getBasicPersonList = async () => {
    queryResult = await pool.query('SELECT * FROM get_basic_person_list()');

    return queryResult.rows;
}




module.exports = {
    getBasicPersonList
}