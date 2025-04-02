const API = 'https://h1-04-java-react-qrtk.onrender.com/v1/api/';

export const fetchDoctors = async (token) => {
  const response = await fetch(`${API}doctors/getAllDoctors`, {
    headers: {
      'Authorization': `Bearer ${token}`
    }
  });
  if (!response.ok) {
    throw new Error('Error fetching doctor data');
  }
  return await response.json();
};

export const getDoctorById = async (token, id) => {
  const response = await fetch(`${API}doctors/getDoctorById/${id}`, {
    headers: {
      'Authorization': `Bearer ${token}`
    }
  });
  if (!response.ok) {
    throw new Error('Error fetching doctor data');
  }
  return await response.json();
};
