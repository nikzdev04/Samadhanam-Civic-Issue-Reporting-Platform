import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.jsx'
import { createBrowserRouter, Outlet, RouterProvider } from 'react-router-dom'
import Login from './components/Login.jsx'
import Home from './components/Home.jsx'
import ComplaintItem from './components/ComplaintItem.jsx'
import React, { useRef } from 'react'
const router = createBrowserRouter([
  {
     path:"/login",
     element:<Login></Login>,
  },

  {
    path:'/',
    element:<App></App>,
    children:[
      {
         path: "District/:id",
         element: <Home></Home>
      },
      {
        path:"Compomplaints/:id",
        element: <ComplaintItem></ComplaintItem>
      },
      
      
    ]
  }
])

createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <RouterProvider router={router}></RouterProvider>
  </React.StrictMode>,
)
