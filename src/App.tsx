import "./App.css";

function App() {
    const appName = import.meta.env.VITE_APP_NAME;
    const appUrl = import.meta.env.VITE_API_URL;

    return (
        <>
            <div>
                <p>Example Single Page App with Vite + ReactJS + Typescript</p>
                <p></p>
                <p>App Name: {appName}</p>
                <p>App URL: {appUrl}</p>
            </div>
        </>
    );
}

export default App;
