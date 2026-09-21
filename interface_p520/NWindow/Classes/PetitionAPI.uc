class PetitionAPI extends Object;

native static function RequestPetitionCancel();

native static function RequestPetition(string a_Message, int a_PetitionType);

native static function RequestPetitionFeedBack(int a_Rate, string a_Message);
