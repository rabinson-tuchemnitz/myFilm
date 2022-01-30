const pool = require('../db');

const storeUser = async (name, email, password, user_role) => {
  await pool.query('SELECT add_user($1, $2, $3, $4)', [
    name,
    email,
    password,
    user_role,
  ]);
};

const getUserFromCredentials = async (email, password) => {
  queryResult = await pool.query(
    'SELECT * FROM get_user_from_credentials($1, $2)',
    [email, password]
  );
  return queryResult.rows[0];
};

const getUserData = async (id) => {
  queryResult = await pool.query('select * from get_user_by_id($1)', [id]);

  return queryResult.rows[0];
};

const updateUser = async (id, name, description) => {
  await pool.query(
    'select update_user_by_id(i_id:=$1, i_name:=$2, i_description:= $3)',
    [id, name, description]
  );
};

module.exports = {
  storeUser,
  getUserFromCredentials,
  getUserData,
  updateUser,
};
