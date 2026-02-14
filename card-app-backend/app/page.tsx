export default function Home() {
  return (
    <main style={{ padding: "2rem", fontFamily: "system-ui" }}>
      <h1>Card App Backend</h1>
      <p>POST to <code>/api/generate-card</code> with JSON body: <code>{"{ imageBase64, cardType }"}</code></p>
      <p>cardType: christmas | birthday | valentines</p>
    </main>
  );
}
