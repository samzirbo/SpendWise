package ro.sam.spendwise.data

data class Transaction(
    val id: Int,
    var name: String,
    var type: String,
    var amount: Double,
    var date: String,
    var details: String?,
) {

    override fun toString(): String {
        return "[$id]" +
                " $name -" +
                " $type -" +
                " $amount -" +
                " ${date} -" +
                " $details"
    }
}