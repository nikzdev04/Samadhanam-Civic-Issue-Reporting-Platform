import axios from 'axios';
import React, { useState } from 'react'
import { useParams } from 'react-router-dom'
import { useEffect } from 'react';
import { toast } from 'react-toastify';
const Home = () => {
  const {id} = useParams();
  const [municipal,setMunicipal] = useState([]);
  useEffect(() => {
    const fetchMunicipality = async () => {
      try {
        const { data } = await axios.post("http://localhost:4040"+"/municipalities/fetchDistrict",{id});
        console.log("Response:", data);

        if (data.success) {
          setMunicipal(data.district);
        } else {
          toast.error(data.message);
        }
      } catch (error) {
        console.error("Error fetching municipality:", error);
        toast.error("Unable to load municipal data");
      } 
    };

    fetchMunicipality();
  }, [id]);
  return (
    <div>
      <div className="w-full">
        <img
          src="https://www.livehindustan.com/lh-img/smart/img/2025/05/10/1200x900/Ghaziabad_Municipal_Corporation__HT_1746349441299_1746867572414.jpg"
          style={{ width: '100%', height: '45vh', objectFit: 'cover' }}
          alt="Ghaziabad Municipal Corporation"
        />
      </div>
      <div className='m-2 p-2'>
        <nav className="bg-white shadow flex items-center justify-between px-8 py-4">
          <div className="flex items-center gap-3">
            <img
              src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjk_Nso7j1og-0E9l16Bie6dMfxGXGvgN-0A&s"
              alt="Logo"
              className="h-12 w-12 rounded-full border"
            />
            <span className="text-blue-700 text-xl font-semibold tracking-wide">
              {municipal.district_name} Municipal Corporation
            </span>
          </div>
          <div className="flex items-center gap-8">
            <span className="text-gray-700 text-lg font-medium">
              14:00:56
            </span>
            <div className="flex items-center gap-2">
              <span className="text-gray-700 font-medium">{municipal.official_username}</span>
            </div>
          </div>
        </nav>
        <div className='flex-col justify-center items-center gap-y-10 md:w-full md:h-1/2 flex md:flex-row md:gap-6 md:p-4 mt-10'>
          <div className='p-15 bg-green-400  md:bg-green-400 md:h-full md:w-1/4 md:p-15 md:flex md:flex-col md:justify-center md:items-center shadow-black shadow-lg rounded-4xl'>
            <h1 className='text-3xl'>Solved</h1>
            <h2 className='text-7xl mt-3'>{municipal.solved}</h2>
          </div>
          <div className='p-15 bg-orange-400  md:bg-orange-400 md:h-full md:w-1/4 md:p-15 md:flex md:flex-col md:justify-center md:items-center shadow-black shadow-lg rounded-4xl'>
            <h1 className='text-3xl'>Pending</h1>
            <h2 className='text-7xl mt-3'>{municipal.pending}</h2>
          </div>
          <div className='p-15 bg-gray-500  md:bg-gray-500 md:h-full md:w-1/4 md:p-15 md:flex md:flex-col md:justify-center md:items-center shadow-black shadow-lg rounded-4xl'>
            <h1 className='text-3xl'>Escalated</h1>
            <h2 className='text-7xl mt-3'>{municipal.demerits}</h2>
          </div>
          <div className='p-15 bg-red-400  md:bg-red-400 md:h-full md:w-1/4 md:p-15 md:flex md:flex-col md:justify-center md:items-center shadow-black shadow-lg rounded-4xl'>
            <h1 className='text-3xl'>Demerits</h1>
            <h2 className='text-7xl mt-3'>{municipal.demerits}</h2>
          </div>
        </div>

        <div className='mt-5 flex-row justify-center mb-5 p-2 shadow-2xl'>
          <input type='text' className='p-2 border rounded-full w-1/5' placeholder='enter your complaint-ID'></input>
          <select
            name="speciality"
            id="speciality"
            className="w-1/4 ml-4 border border-gray-300 px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-400 rounded-2xl"
          >
            <option value="">Pothhole</option>
            <option value="ENT">Garbage</option>
            <option value="Child Specialist">Street Light</option>
            <option value="diabeties">Drainage</option>
            <option value="Endocrinologist">Sewage</option>
            <option value="Gastroenterologist">Roads</option>
            <option value="Cardiologist">Traffic light</option>
          </select>
          <input type='date' className='p-2 border rounded-full w-1/5 ml-4' placeholder='select by date'></input>
          <button className='bg-blue-600 pl-4 pr-4 pt-2 pb-2 text-white ml-4 rounded-3xl text-2xl'>Apply Filter</button>
          <button className='bg-green-500 pl-4 pr-4 pt-2 pb-2 text-white ml-4 rounded-3xl text-2xl'>Show all complaints</button>
        </div>
        <div className="overflow-x-auto mt-6">
          <table className="min-w-full border border-gray-300 rounded-lg shadow-lg">
            <thead className="bg-blue-600 text-white">
              <tr>
                <th className="px-6 py-3 text-left font-semibold">Complaint ID</th>
                <th className="px-6 py-3 text-left font-semibold">Category</th>
                <th className="px-6 py-3 text-left font-semibold">Date</th>
                <th className="px-6 py-3 text-left font-semibold">Status</th>
                <th className="px-6 py-3 text-left font-semibold">Assigned To</th>
                <th className="px-6 py-3 text-left font-semibold">Details</th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {/* {municipal.complaints.map((complaint) => (
                <tr key={complaint.id}>
                  <td className="px-6 py-4">{complaint.id}</td>
                  <td className="px-6 py-4">{complaint.category}</td>
                  <td className="px-6 py-4">{complaint.date}</td>
                  <td className="px-6 py-4">
                    <span className={`bg-${complaint.status === "Solved" ? "green" : "red"}-100 text-${complaint.status === "Solved" ? "green" : "red"}-800 px-2 py-1 rounded-full text-xs`}>
                      {complaint.status}
                    </span>
                  </td>
                  <td className="px-6 py-4">{complaint.assignedTo}</td>
                  <td>
                    <button className='bg-orange-500 p-3 text-white rounded-2xl'>View Details</button>
                  </td>
                </tr>
              ))} */}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  )
}

export default Home;


