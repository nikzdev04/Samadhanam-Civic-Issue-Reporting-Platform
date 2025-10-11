import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'
import Login from './components/Login'
import Home from './components/Home'
import ComplaintItem from './components/ComplaintItem'
import { Outlet } from 'react-router-dom'

function App() {
    return (
      // <Login></Login>
      <div>
          <Outlet></Outlet>
      </div>
      // <ComplaintItem></ComplaintItem>
    )
  
}

export default App
