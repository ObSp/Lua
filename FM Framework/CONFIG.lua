return {
    --//Shallow Service Settings//--

     -- Where non-existent keys should send a request to the server, ex. shallowservice.x(), x doesn't exist so a request would
     -- be sent to the server to get the "x" function from the real service
     -- IMPORTANT: THIS CAN BE DANGEROUS AS IT ALLOWS THE CLIENT TO INTERACT WITH THE SERVER IN UNCHECKED WAYS.
     -- PLEASE MAKE SURE TO IMPLEMENT SERVER-SIDE CHECKS WHEN ENABLING THIS
    AUTO_INDEX_TO_SERVER = false
}