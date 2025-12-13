export function provideYear(){
    let year = new Date().getFullYear();
    return year;
}
export async function fileToBase64(file){
        let arrayBuffer = await file.arrayBuffer();
        let bytes = new Uint8Array(arrayBuffer);

        let binary = "";
        for (let b of bytes) {
            binary += String.fromCharCode(b);
        }

        return btoa(binary);
    }
