import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'
import Login from './components/login'
import Home from './components/home'
import All_district from './components/all_district'


function App() {
  

  return (
  <div>
    
      <div className="w-full">
        <img
          src="https://sadup.gov.in/site/writereaddata/HomePage/Header/H_201604261127165118.jpg"
          style={{ width: '100%', height: '65vh', objectFit: 'cover' }}
          alt="Ghaziabad Municipal Corporation"
        />
      </div>
      <nav className="bg-white shadow flex items-center justify-between px-8 py-4">
          <div className="flex items-center gap-3">
            <img
              src="https://w7.pngwing.com/pngs/560/130/png-transparent-government-of-india-government-of-uttar-pradesh-uttar-pradesh-police-uttar-pradesh-subordinate-services-selection-commission-others-thumbnail.png"
              alt="Logo"
              className="h-12 w-12 rounded-full border"
            />
            <span className="text-blue-700 text-xl font-semibold tracking-wide">
              Uttar Pradesh State government
            </span>
          </div>
          <div className="flex flex-col gap-3 md:flex-row md:gap-8">
                <div className="text-1xl hover:text-2xl">
                      <a href="/complaints">Complaints</a>
                </div>
                <div className="text-1xl hover:text-2xl">
                        <a href="/district">District</a>
                </div>
          </div>
          <div className="flex items-center gap-8">
            <span className="text-gray-700 text-lg font-medium">
              14:00:56
            </span>
            <div className="flex items-center gap-2">
              <span className="text-gray-700 font-medium">John Doe</span>
            </div>
          </div>
        </nav>
        <All_district></All_district> 
         <Home></Home>
        {/* <Login></Login> */}
    </div>

            
    
  )
}

export default App
