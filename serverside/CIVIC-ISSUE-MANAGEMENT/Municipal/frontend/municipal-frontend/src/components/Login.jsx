import React, { useRef } from 'react'
import axios from 'axios';
const Login = () => {
  const emailRef = useRef();
  const passwordRef = useRef();
  const handleSubmit = async(e) => {
    e.preventDefault();
    const email = emailRef.current.value;
    const password = passwordRef.current.value;
    emailRef.current.value = "";
    passwordRef.current.value = "";
    try {
          const res = await axios.post("http://localhost:5000" + "/municipalities/login", {email, password});

    } 
    catch (error) {
      
    }
  }

  return (
    <div
      className="min-h-screen flex items-center justify-center bg-gray-100"
      style={{
        backgroundImage:
          "url('https://content.jdmagicbox.com/comp/jaipur/e1/0141px141.x141.140728095759.j2e1/catalogue/jaipur-nagar-nigam-shastri-nagar-jaipur-municipal-corporation-v9qat33jt7.jpg')",
        backgroundSize: "cover",
        backgroundPosition: "center",
        
      }}
    >
      <form className="bg-transparent bg-opacity-95 rounded-xl border-2 shadow-white shadow-xl text-white font-bold p-8 w-full max-w-md flex flex-col gap-9">
        <h2 className="text-4xl font-bold text-center ">MUNICIPAL LOGIN</h2>
        <div>
          <label htmlFor="email" className="block text-sm font-medium ">
            Email
          </label>
          <input
            type="email"
            id="email"
            name="email"
            ref={emailRef}
            className="w-full px-4 py-2 border-2 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            required
            autoComplete="email"
          />
        </div>
        <div>
          <label htmlFor="password" className="block text-sm font-medium ">
            Password
          </label>
          <input
            type="password"
            id="password"
            name="password"
            ref={passwordRef}
            className="w-full px-4 py-2 border-2 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            required
            autoComplete="current-password"
          />
        </div>
        <button
          type="submit"
          className="w-full bg-blue-600 text-white font-semibold py-2 rounded-lg hover:bg-blue-700 transition-colors"
          onClick={handleSubmit}
        >
          Login
        </button>
        {/* <div className="text-center mt-2">
          <a href="#" className="text-sm text-blue-600 hover:underline">
            Forgot password?
          </a>
        </div> */}
      </form>
    </div>
  )
}

export default Login
